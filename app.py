"""
Pitrot A Simple Issue Tracker

__author__ : Çağatay Tengiz
__date__   : 15.11.2013
"""

import os
import importlib
import logging
import sys

import bottle
from beaker.middleware import SessionMiddleware
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm.scoping import scoped_session

from i18n import _
import dbcon
import utils
import install
from controllers.index import index

#Bottle Max Mem Size Limit
bottle.BaseRequest.MEMFILE_MAX = 50000000 #50 MB

if hasattr(sys, 'frozen'):
    BASE_PATH = os.path.dirname(os.path.abspath(sys.argv[0]))
else:
    BASE_PATH = os.path.abspath(os.path.dirname(__file__))

baseApp = bottle.Bottle()


def sub_import(asrc):
    _controllers_dir = '%s/%s/' %(BASE_PATH, asrc)
    _lst = os.listdir(_controllers_dir)
    for _fname in _lst:
        _module_name, _module_ext = os.path.splitext(_fname)
        _module_path = '%s%s' %(_controllers_dir, _fname)
        if not os.path.isdir(_module_path) and _fname[0:2] != '__' and _module_ext == '.py':
            module = importlib.import_module('%s.%s' %(asrc, _module_name))
            module.subApp.install(dbcon.plugin_sqlalchemy)
            baseApp.merge(module.subApp.routes)


def init_app():
    #load config
    baseApp.config.load_config('%s/config.ini' %BASE_PATH)
    baseApp.config['general.base_path'] = BASE_PATH

    #init sa
    dbcon.init_sa(baseApp.config)
    baseApp.install(dbcon.plugin_sqlalchemy)

    #Importing controllers
    sub_import('controllers')
    sub_import('apis')

    #logging
    if baseApp.config['general.debugging_on'] == '1':
        logging.basicConfig(filename='%s/debug.log' % BASE_PATH,
                            format='%(asctime)s %(levelname)s %(message)s',
                            level=logging.DEBUG)

    #template defaults
    bottle.BaseTemplate.defaults['_'] = _
    bottle.BaseTemplate.defaults['session'] = bottle.request.environ.get('beaker.session')
    bottle.BaseTemplate.defaults['request'] = bottle.request
    bottle.BaseTemplate.defaults['current_date'] = utils.current_date_as_str
    bottle.BaseTemplate.defaults['date_to_str'] = utils.datetime_to_str
    bottle.BaseTemplate.defaults['list_usr_projects'] = utils.list_usr_projects
    bottle.BaseTemplate.defaults['config'] = baseApp.config
    bottle.BaseTemplate.defaults['render_comment'] = utils.render_comment


def run_app(do_debug=True):
    if not(os.path.exists(BASE_PATH + '/config.ini')):
        baseApp.config['general.base_path'] = BASE_PATH

        baseApp.route('/', method=['GET', 'POST'], callback=install.do_setup)
        baseApp.route('/setup_ok', method=['GET', 'POST'], callback=install.setup_ok)
        _cookie_expires = 18000
        install.in_setup = True
    else:
        init_app()
        _cookie_expires = int(baseApp.config['auth.session_timeout'])

    return SessionMiddleware(baseApp, {'session.type': 'file',
                                       'session.cookie_expires': _cookie_expires,
                                       'session.data_dir': BASE_PATH + '/sessions',
                                       'session.auto': True})



@baseApp.hook('before_request')
def setup_request():
    s = bottle.request.environ['beaker.session']
    if not 'logged_in' in s:
        utils.init_session()
    bottle.request.session = s

    dst_path = bottle.request.urlparts.path.split('/')[1]
    if install.in_setup:
        return

    if baseApp.config['auth.login_required'] == '1':
        if not(s.get('logged_in')):
            if dst_path != 'static' and dst_path != '/favicon.ico' and dst_path != 'login':
                s['path'] = bottle.request.urlparts.path
                bottle.redirect('/login')

    if dst_path == 'admin':
        if not(s.get('is_admin')):
            bottle.abort(401, _('Admin rights required for this section'))

    bottle.BaseTemplate.defaults['db'] = scoped_session(sessionmaker(bind=dbcon.engine))

    #todo: check if this is really needed.
    bottle.BaseTemplate.defaults['session'] = s


@baseApp.hook('after_request')
def release_dbsession():
    if 'db' in bottle.BaseTemplate.defaults:
        bottle.BaseTemplate.defaults['db'].remove()


@baseApp.get('/static/<filepath:path>')
def server_static(filepath):
    return bottle.static_file(filepath, root='%s/static' %baseApp.config['general.base_path'])


@baseApp.get('/favicon.ico')
def favicon():
    print('favicon.ico')
    return bottle.static_file('favicon.ico', root='%s/static/assets/' %baseApp.config['general.base_path'])


@baseApp.get('/uploads/<filepath:path>')
def serve_upload(db, filepath):
    _uuid = filepath
    if filepath[:3] == 'th_':
        _uuid = filepath[3:]

    rec = db.query(dbcon.Upload).filter(dbcon.Upload.uuid == _uuid).first()
    if rec:
        return bottle.static_file(filepath,
                                  root='%s/uploads' %baseApp.config['general.base_path'],
                                  download=rec.file_name,
                                  mimetype=rec.mimetype)

if __name__ == '__main__':
    bottle.debug(True)
    appM = run_app()
    bottle.run(app=appM, host="0.0.0.0", port=18002, reloader=False)
else:
    appM = run_app()
    application = appM

