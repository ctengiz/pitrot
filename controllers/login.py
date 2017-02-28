# -*- coding: utf-8 -*-

"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 20.12.2013
"""
from bottle import Bottle, request, redirect, template

import dbcon
from utils import init_session, render
from ldap3 import Server, Connection
from ldap3 import AUTH_SIMPLE, STRATEGY_SYNC, GET_ALL_INFO


subApp = Bottle()

@subApp.route('/login', method=['GET', 'POST'])
def login(db):
    self_registration = request.app.config['auth.self_registration']
    active_directory_server = request.app.config['auth.active_directory_server']

    s = request.session
    if s.get('logged_in'):
        redirect('/')

    if request.method == 'GET':
        return render('login', self_registration=self_registration, error=False, usr_code=None)
    else:
        usr_code = request.POST.code
        password = request.POST.upass

        ausr = db.query(dbcon.Usr).filter(dbcon.Usr.code == usr_code).first()
        check_login = False

        if ausr:

            if ausr.auth_method == 0:
                check_login = password == ausr.upass
            else:
                #lets do active directory auth
                s = Server(active_directory_server, port=389, get_info=GET_ALL_INFO)
                try:
                    c = Connection(s,
                                   auto_bind=True,
                                   client_strategy=STRATEGY_SYNC,
                                   user='%s\\%s' %(ausr.dc_name, usr_code),
                                   password=password,
                                   authentication=AUTH_SIMPLE)
                    check_login = True
                    c.unbind()
                except:
                    check_login = False

        if check_login:

            s = request.environ.get('beaker.session')
            s['usr_code'] = usr_code
            s['usr_email'] = ausr.email
            s['usr_full_name'] = ausr.full_name
            s['is_admin'] = ausr.is_admin
            s['logged_in'] = True
            s['usr_id'] = ausr.id
            s['self_notification'] = ausr.ck_notification_self

            redirect(s['path'])
        else:
            return render('login', self_registration=self_registration, error=True, usr_code=usr_code)


@subApp.route('/logout')
def logout():
    init_session()
    redirect('/')

