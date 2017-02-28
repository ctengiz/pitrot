# -*- coding: utf-8 -*-

"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 16.03.2014
"""

from bottle import Bottle, request, abort, redirect, template
from sqlalchemy import exc, func, and_, or_

from utils_sa import formdata_to_sa
from utils import render, decode_config_base64, send_mail, \
    get_priority_list, get_status_list, get_category_list, get_milestone_list, \
    list_issues, \
    list_last_updates, is_usr_admin
from i18n import _
from dbcon import Issue, Usr, Project_Usr, Project, Client, Project_Status

subApp = Bottle()


@subApp.route('/user/<code>', method='GET')
@subApp.route('/user/<ndx:int>', method='GET')
@subApp.route('/user/<code>/<page>', method='GET')
@subApp.route('/user/<ndx:int>/<page>', method='GET')
def usr_view(db, code="", ndx=0, page='overview'):

    _prms = request.GET

    if ndx != 0:
        _arec = db.query(Usr).filter(Usr.id == ndx).first()
    else:
        _arec = db.query(Usr).filter(Usr.code == code).first()
    
    if not _arec:
        abort(404, _('This user does not exists !'))

    #todo more proper grant control
    if not is_usr_admin(db) and _arec.id != request.session['usr_id']:
        abort(403, _('You are not granted to access this page'))

    if page == 'overview':
        _issue_summary = db.query(Project_Status.nro,
                                  Project_Status.code,
                                  func.count(Issue.id).label('cnt')).\
            join(Issue).\
            filter(Issue.usr_id_assigned == _arec.id).\
            order_by(Project_Status.nro).\
            group_by(Project_Status.nro, Project_Status.code).\
            all()

        _prj_summary = db.query(Issue.status_nro,
                                Issue.status,
                                Issue.status_id,
                                Issue.project_code,
                                Issue.project_id,
                                func.count(Issue.id).label('cnt')).\
            filter(and_(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id']),
                        Issue.usr_id_assigned == _arec.id)).\
            order_by(Issue.project_code, Issue.status_nro).\
            group_by(Issue.status_id, Issue.project_id).\
            all()

        #Issue summary by client
        _ismry = db.query(Project_Status.nro.label("status_nro"),
                          Project_Status.code.label("status"),
                          func.count(Issue.id).label('cnt'),
                          db.query(Project.client_id).filter("Project.id = issue.project_id").label("client_id")
                          ).\
            join(Issue).\
            filter(and_(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id']),
                        Issue.usr_id_assigned == _arec.id)).\
            order_by(Project_Status.nro).\
            group_by(Project_Status.nro, Project_Status.code, Issue.project_id).\
            subquery()

        _client_summary = db.query(Client.id,
                                   Client.code,
                                   _ismry.c.status_nro,
                                   _ismry.c.status,
                                   func.count(_ismry.c.cnt).label('cnt')).\
            join(_ismry, _ismry.c.client_id == Client.id).\
            order_by(Client.code).\
            group_by(Client.id, Client.code, _ismry.c.status, _ismry.c.status_nro).\
            all()

        return render('user_tab_overview',
                      arec=_arec,
                      page=page,
                      issue_summary=_issue_summary,
                      prj_summary=_prj_summary,
                      client_summary=_client_summary)

    elif page == 'issues':
        cats = get_category_list(db, None)
        stas = get_status_list(db, None)
        prit = get_priority_list(db, None)
        mile = get_milestone_list(db, None)

        return render('user_tab_%s' % page,
                      arec=_arec,
                      issues=list_issues(db, usr_id=_arec.id),
                      page=page,
                      cats=cats, stas=stas, prit=prit, mile=mile,
                      tabtype='assigned')

    elif page == 'issues_opened':
        cats = get_category_list(db, None)
        stas = get_status_list(db, None)
        prit = get_priority_list(db, None)
        mile = get_milestone_list(db, None)

        return render('user_tab_issues',
                      arec=_arec,
                      issues=list_issues(db, usr_id_from=_arec.id),
                      page=page,
                      cats=cats, stas=stas, prit=prit, mile=mile,
                      tabtype="opened")

    elif page == 'issues_watched':
        cats = get_category_list(db, None)
        stas = get_status_list(db, None)
        prit = get_priority_list(db, None)
        mile = get_milestone_list(db, None)

        return render('user_tab_issues',
                      arec=_arec,
                      issues=list_issues(db, usr_id_watch=_arec.id),
                      page=page,
                      cats=cats, stas=stas, prit=prit, mile=mile,
                      tabtype="watched")

    elif page == 'activity':
        return render('user_tab_%s' % page,
                      arec=_arec,
                      page=page,
                      activity=list_last_updates(db, usr_id=_arec.id, rows=10000))

    elif page == 'worklog':
        return render('user_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'files':
        return render('user_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'calendar':
        return render('user_tab_%s' % page,
                      arec=_arec,
                      page=page)
    




__base_url = '/admin/user'
@subApp.route(__base_url)
@subApp.route(__base_url + '/<act>', method=['GET', 'POST'])
@subApp.route(__base_url + '/<act>/<ndx>', method=['GET', 'POST'])
def admin_usr(db, act="lst", ndx=0):

    #todo: code clean-up

    #todo more proper grant control
    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    atmp = request.urlparts.path.split('/')[2]
    apth = "/admin/%s" % atmp

    atbl = Usr
    brd = [{"link": apth, "defi": _("Users")}]

    if request.method == 'GET':

        if act == "lst":
            alst = db.query(atbl).order_by(atbl.id).all()
            return render('%s_list.tpl' % atmp, alst=alst, breadcumb=brd)

        elif act == "edit":
            brd.append({"link": "", "defi": _("Edit")})

            arec = db.query(atbl).filter(atbl.id == ndx).first()
            if arec:
                return render('%s_edit.tpl' % atmp, arec=arec, breadcumb=brd)
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
            #todo: try-except block
            db.commit()
            redirect('/adm/user/lst')
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
            #Ön tanımlı değerleri verelim
            #Bir de html formu tarafından gönderilmeyen değerleri
            arec.is_admin = 0
            arec.ck_notification_project = 0
            arec.ck_notification_self = 0
            arec.ck_notification_public_project = 0
            arec.ck_notification_watcher = 0
            arec.auth_method = 0

            formdata_to_sa(data, atbl, arec)

            _pl = request.params.getall('project_id')
            _rl = request.params.getall('usrrole_id')
            #Önceki kayıtları silelim
            _old = db.query(Project_Usr).filter(Project_Usr.usr_id == arec.id)
            _old.delete()
            #yeni kayıtları ekleyelim
            for _project_id in _pl:
                _usr_role_id = _rl[_pl.index(_project_id)]
                _project_usr_row = Project_Usr()
                _project_usr_row.usr_id = arec.id
                _project_usr_row.project_id = _project_id
                _project_usr_row.usrrole_id = _usr_role_id
                db.add(_project_usr_row)

            try:
                db.commit()
                #mail gönderim işlemini yapalım
                if atbl == Usr:
                    if 'ck_inform' in data:
                        _mail_template = decode_config_base64(request.app.config['mail.register_mail'])
                        _mail_text = template(_mail_template, code=data['code'], upass=data['upass'], arec=arec)

                        send_mail(
                            data['email'],
                            '%s %s' %(request.app.config['general.site_title'], _('Login Information')),
                            _mail_text
                        )

                #todo: burada ileride json dönmeliyiz !
                redirect(apth)
            except exc.SQLAlchemyError as err:
                db.rollback()
                abort(500,
                      _("Error in processing DB operation.<br\>Please try again! DB Error Msg:<br/>%s") % err)
