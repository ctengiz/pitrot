
"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 20.12.2013
"""

import datetime
from bottle import Bottle, request
from i18n import _
from utils import render, \
    list_usr_projects, \
    list_usr_opened_issues, \
    list_usr_assigned_issues, \
    list_last_updates

subApp = Bottle()

@subApp.get('/')
def index(db):
    #todo: anasayfada duyuru da olsun
    #todo: if user is admin then select all projects
    _project = list_usr_projects(db)
    _issue_from_usr = list_usr_opened_issues(db, filter_closed=True)
    _issue_assigned_usr = list_usr_assigned_issues(db, filter_closed=True)
    _last_updates = list_last_updates(db)

    return render('homepage.tpl',
                  _prj=_project,
                  _issue=_issue_from_usr,
                  _issue_to=_issue_assigned_usr,
                  _updates=_last_updates)
