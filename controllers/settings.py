# -*- coding: utf-8 -*-

"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 25.04.2014
"""

import configparser
import base64

from bottle import Bottle, request, redirect

from i18n import _
from utils import read_config_file, render, decode_config_base64

subApp = Bottle()


@subApp.route('/admin/settings', method='GET')
def admin_settings(db):
    breadcumb = [
        {'link': 'admin', 'defi': _('Admin')},
        {'link': '#', 'defi': _('Settings')}
    ]

    print(request.app.config['general.base_path'])
    aconfig = read_config_file(request.app.config['general.base_path'])

    issue_mail = decode_config_base64(aconfig['mail']['issue_mail'])
    register_mail = decode_config_base64(aconfig['mail']['register_mail'])

    return render('settings', breadcumb=breadcumb, cnf=aconfig,
                  issue_mail=issue_mail,
                  register_mail=register_mail)

@subApp.route('/admin/settings', method='POST')
def admin_settings_post(db):
    pd = request.POST

    aconfig = configparser.ConfigParser()

    aconfig['general'] = {
        'site_url': pd.site_url,
        'site_brand': pd.site_brand,
        'site_title': pd.site_title,
        'welcome_text': pd.welcome_text,
        'footer_text': pd.footer_text,
        'test_run': pd.test_run,
        'debugging_on': pd.debugging_on,
        'thumb_size': pd.thumb_size,
        'image_size': pd.image_size,
        'store_files_in_db': pd.store_files_in_db,
        'template': pd.template

    }

    aconfig['database'] = {
        'db_type': pd.db_type,
        'db_server': pd.db_server,
        'db_path': pd.db_path,
        'db_user': pd.db_user,
        'db_pass': pd.db_pass,
        'echo_sqlalchemy': pd.echo_sqlalchemy,
    }

    aconfig['auth'] = {
        'login_required': pd.login_required,
        'self_registration': pd.self_registration,
        'active_directory_server': pd.active_directory_server,
        'session_timeout': pd.session_timeout
    }

    aconfig['mail'] = {
        'server': pd.m_server,
        'address': pd.m_address,
        'from': pd.m_from,
        'login': pd.m_login,
        'password': pd.m_password,
        'start_tls': pd.m_start_tls,
        'port': pd.m_port,
        'issue_mail': base64.b64encode(bytes(pd.issue_mail, 'utf-8')),
        'register_mail': base64.b64encode(bytes(pd.register_mail, 'utf-8')),
    }

    with open('%s/config.ini' % request.app.config['general.base_path'], 'w+', encoding="utf-8") as configfile:
        aconfig.write(configfile)


    for section in aconfig.sections():
        for key, value in aconfig.items(section):
            key = section + '.' + key
            request.app.config[key] = value

    redirect('/')
