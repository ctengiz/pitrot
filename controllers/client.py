
"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 25.04.2014
"""

from bottle import Bottle, request, abort, redirect
from sqlalchemy import exc, func, and_, or_

from utils_sa import formdata_to_sa
from utils import render, \
    get_category_list, get_status_list, get_priority_list, get_milestone_list, \
    list_issues, list_last_updates, \
    is_usr_admin, check_usr_client

from i18n import _
import dbcon
from dbcon import Issue, WorkLog, Upload, Client, Project_Status

subApp = Bottle()



@subApp.route('/client/<code>', method='GET')
@subApp.route('/client/<ndx:int>', method='GET')
@subApp.route('/client/<code>/<page>', method='GET')
@subApp.route('/client/<ndx:int>/<page>', method='GET')
def client_view(db, code="", ndx=0, page='overview'):
    
    _prms = request.GET

    if ndx != 0:
        _arec = db.query(Client).filter(Client.id == ndx).first()
    else:
        _arec = db.query(Client).filter(Client.code == code).first()
    
    if _arec:
        if not check_usr_client(db, _arec.id):
            abort(403,  _('You are not assigned to this client !'))
    else:
        abort(404, _('This client does not exists !'))
    
    if page == 'overview':
        _issue_summary = db.query(Project_Status.nro,
                                  Project_Status.code,
                                  func.count(Issue.id).label('cnt')).\
            join(Issue).\
            filter(and_("(select p.client_id from project p where p.id = issue.project_id) = :client_id",
                        "(select p.is_active from project p where p.id = issue.project_id) = 1",
                        or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id']))).\
            params(client_id=_arec.id).\
            order_by(Project_Status.nro).\
            group_by(Project_Status.nro, Project_Status.code).\
            all()

        _prj_summary = db.query(Issue.status_nro,
                                Issue.status,
                                Issue.project_code,
                                Issue.project_id,
                                Issue.status_id,
                                func.count(Issue.id).label('cnt')).\
            filter(and_("(select p.client_id from project p where p.id = issue.project_id) = :client_id",
                        "(select p.is_active from project p where p.id = issue.project_id) = 1",
                        or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id'])
            )).\
            params(client_id=_arec.id).\
            order_by(Issue.project_code, Issue.status_nro).\
            group_by(Issue.status_id, Issue.project_id).\
            all()

        _usr_summary = db.query(Project_Status.nro,
                                 Project_Status.code,
                                 Issue.usr_code_assigned,
                                 Issue.usr_id_assigned,
                                 func.count(Issue.id).label('cnt')). \
            join(Issue).\
            filter(and_("(select p.client_id from project p where p.id = issue.project_id) = :client_id",
                        "(select p.is_active from project p where p.id = issue.project_id) = 1",
                        or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id'])
            )).\
            params(client_id=_arec.id).\
            order_by(Issue.usr_code_assigned, Project_Status.nro).\
            group_by(Project_Status.nro, Project_Status.code, Issue.usr_id_assigned).\
            all()

        return render('client_tab_overview',
                      arec=_arec,
                      page=page,
                      prj_summary=_prj_summary,
                      issue_summary=_issue_summary,
                      usr_summary=_usr_summary)

    elif page == 'issues':
        cats = get_category_list(db, None)
        stas = get_status_list(db, None)
        prit = get_priority_list(db, None)
        mile = get_milestone_list(db, None)

        return render('client_tab_%s' % page,
                      arec=_arec,
                      issues=list_issues(db, client_id=_arec.id),
                      page=page,
                      cats=cats, stas=stas, prit=prit, mile=mile)

    elif page == 'activity':
        return render('client_tab_%s' % page,
                      arec=_arec,
                      page=page,
                      activity=list_last_updates(db, client_id=_arec.id, rows=10000))

    elif page == 'worklog':
        _wlog = db.query(WorkLog).\
            filter(WorkLog.client_code == _arec.code).all()
        return render('client_tab_%s' % page,
                      arec=_arec,
                      lst_worklog = _wlog,
                      page=page)

    elif page == 'files':
        _arec = db.query(Upload).all()
        return render('client_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'calendar':
        return render('client_tab_%s' % page,
                      page=page,
                      arec=_arec)


__base_url = '/admin/client'
@subApp.route(__base_url)
@subApp.route(__base_url + '/<act>', method=['GET', 'POST'])
@subApp.route(__base_url + '/<act>/<ndx>', method=['GET', 'POST'])
def admin_category(db, act="lst", ndx=0):

    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    atmp = request.urlparts.path.split('/')[2]
    apth = "/admin/%s" % atmp

    atbl = dbcon.Client
    brd = [{"link": apth, "defi": _("Categories")}]

    if request.method == 'GET':

        if act == "lst":
            alst = db.query(atbl).order_by(atbl.id).all()
            return render('%s_list.tpl' % atmp, alst=alst, breadcumb=brd, base_url=__base_url)

        elif act == "edit":
            brd.append({"link": "", "defi": _("Edit")})

            arec = db.query(atbl).filter(atbl.id == ndx).first()
            if arec:
                return render('%s_edit.tpl' % atmp, arec=arec, breadcumb=brd, base_url=__base_url)
            else:
                abort(404, _('No record found'))

        elif act == "add":
            brd.append({"link": "", "defi": _("New")})
            arec = atbl()
            arec.id = 0

            return render('%s_edit.tpl' % atmp, arec=arec, breadcumb=brd)

        elif act == "del":
            data = db.query(atbl).filter(atbl.id == ndx).first()
            if not data:
                abort(404, _("No record to delete"))

            db.delete(data)
            redirect(apth)
        else:
            abort(404, _('Operation type %s is not supported')% (act, ))

    else:
        data = request.POST

        if act == "add":
            arec = atbl()
            db.add(arec)
        else:
            arec = db.query(atbl).filter(atbl.id == ndx).first()

        if act in ['add', 'edit']:
            formdata_to_sa(data, atbl, arec)

            try:
                db.commit()

                #todo: burada ileride json dönmeliyiz !
                redirect(apth)
            except exc.SQLAlchemyError as err:
                db.rollback()
                abort(500,
                      _("Error in processing DB operation.<br\>Please try again! DB Error Msg:<br/>%s") % err)