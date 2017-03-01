"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 19.12.2013
"""
import json

from bottle import Bottle, request, abort
from sqlalchemy import and_, or_
from sqlalchemy.sql import func

from i18n import _

from dbcon import Issue, WorkLog, Upload, Client, Project
from utils import render, list_last_updates, list_issues, get_category_list, get_status_list, get_priority_list, is_usr_admin

subApp = Bottle()

@subApp.route('/overview')
@subApp.route('/overview/<page>')
def overview(db, page="overview"):

    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    if page == 'overview':
        _issue_summary = db.query(Issue.status_nro,
                                  Issue.status,
                                  Issue.status_id,
                                  func.count(Issue.id).label('cnt')).\
            filter(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id'])).\
            order_by(Issue.status_nro).\
            group_by(Issue.status_id).\
            all()

        _prj_summary = db.query(Issue.status_nro,
                                Issue.status,
                                Issue.status_id,
                                Issue.project_code,
                                Issue.project_id,
                                func.count(Issue.id).label('cnt')).\
            filter(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id'])).\
            order_by(Issue.project_code, Issue.status_nro).\
            group_by(Issue.status_id, Issue.project_id).\
            all()

        #Issue summary by client
        _ismry = db.query(Issue.status_nro.label("status_nro"),
                          Issue.status.label("status"),
                          Issue.status_id.label("status_id"),
                          func.count(Issue.id).label('cnt'),
                          db.query(Project.client_id).filter("Project.id = issue.project_id").label("client_id"),).\
            filter(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id'])).\
            order_by(Issue.status_nro).\
            group_by(Issue.status_id, Issue.project_id).\
            subquery()

        _client_summary = db.query(Client.id,
                                   Client.code,
                                   _ismry.c.status_nro,
                                   _ismry.c.status,
                                   _ismry.c.status_id,
                                   func.count(_ismry.c.cnt).label('cnt')).\
            outerjoin(_ismry, _ismry.c.client_id == Client.id).\
            order_by(Client.code).\
            group_by(Client.id, Client.code, _ismry.c.status, _ismry.c.status_nro, _ismry.c.status_id).\
            all()

        _usr_summary = db.query(Issue.status_nro,
                                Issue.status,
                                Issue.status_id,
                                Issue.usr_code_assigned,
                                Issue.usr_id_assigned,
                                func.count(Issue.id).label('cnt')).\
            filter(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id'])).\
            order_by(Issue.usr_code_assigned, Issue.status_nro).\
            group_by(Issue.status_id, Issue.usr_id_assigned).\
            all()

        return render('overview_tab_overview',
                      page=page,
                      issue_summary=_issue_summary,
                      prj_summary=_prj_summary,
                      client_summary=_client_summary,
                      usr_summary=_usr_summary)

    elif page == 'issues':
        cats = get_category_list(db)
        stas = get_status_list(db)
        prit = get_priority_list(db)

        return render('overview_tab_%s' % page,
                      issues=list_issues(db),
                      page=page,
                      cats=cats, stas=stas, prit=prit)

    elif page == 'activity':
        return render('overview_tab_%s' % page,
                      page=page,
                      activity=list_last_updates(db, rows=10000))

    elif page == 'worklog':
        _arec = db.query(WorkLog).all()
        return render('overview_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'files':
        _arec = db.query(Upload).all()
        return render('overview_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'calendar':
        return render('overview_tab_%s' % page,
                      page=page)


