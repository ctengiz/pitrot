"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 19.12.2013
"""
import json

from bottle import Bottle, request, abort, redirect
from sqlalchemy import exc, and_, or_
from sqlalchemy.sql import func

from upload import upload_file
from utils_sa import formdata_to_sa
from i18n import _
from dbcon import Project, Project_Usr, Issue, Upload, Project_Upload, Project_Category, Project_Milestone, \
    Project_Status
from utils import check_usr_project, try_commit, render, list_last_updates, list_issues, \
    get_category_list, get_status_list, get_priority_list, is_usr_admin, get_milestone_list


subApp = Bottle()


@subApp.route('/project')
def project_list(db):
    #todo: check grants

    #todo more proper grant control
    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    request.session['current_project'] = ""

    alst = db.query(Project).all()
    brd = [{"link": "", "defi": _("Projects")}]
    return render('project_list.tpl', alst=alst, breadcumb=brd)


@subApp.route('/project/<project_code>')
@subApp.route('/project/<project_code>/<page>')
def project(db, project_code, page="overview"):
    """

    :param db:
    """

    _prms = request.GET

    _arec = db.query(Project).filter(Project.code == project_code).first()

    if _arec:
        if not check_usr_project(db, _arec.id):
            abort(404,  _('You are not assigned to this project !'))
    else:
        abort(404, _('This project does not exists !'))

    request.session['current_project'] = project_code

    if page == 'overview':
        _issue_summary = db.query(Issue.status_nro,
                                  Issue.status,
                                  Issue.status_id,
                                  func.count(Issue.id).label('cnt')).\
            filter(and_(Issue.project_id == _arec.id,
                        or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id']))).\
            order_by(Issue.status_nro).\
            group_by(Issue.status_id).\
            all()

        _usr_summary = db.query(Issue.status_nro,
                                Issue.status,
                                Issue.status_id,
                                Issue.usr_code_assigned,
                                Issue.usr_id_assigned,
                                func.count(Issue.id).label('cnt')).\
            filter(and_(or_(Issue.is_private == 0, Issue.usr_id_from == request.session['usr_id']),
                        Issue.project_id == _arec.id)).\
            order_by(Issue.usr_code_assigned, Issue.status_nro).\
            group_by(Issue.status_id, Issue.usr_id_assigned).\
            all()

        return render('project_tab_overview',
                      arec=_arec,
                      page=page,
                      issue_summary=_issue_summary,
                      usr_summary=_usr_summary)

    elif page == 'issues':
        #todo: grant check
        cats = get_category_list(db, _arec.id)
        stas = get_status_list(db, _arec.id)
        prit = get_priority_list(db, _arec.id)
        mile = get_milestone_list(db, _arec.id)

        return render('project_tab_%s' % page,
                      arec=_arec,
                      issues=list_issues(db, project_id=_arec.id),
                      page=page,
                      cats=cats,
                      stas=stas,
                      prit=prit,
                      mile=mile)

    elif page == 'activity':
        #todo: grant check

        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page,
                      activity=list_last_updates(db, project_id=_arec.id, rows=10000)
        )

    elif page == 'worklog':
        #todo: grant check

        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'files':
        #todo: grant check

        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page)


    elif page == 'calendar':
        #todo: grant check

        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'roadmap':
        #todo: grant check

        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page)

    elif page == 'settings':
        #todo: check if user is project admin

        if not is_usr_admin(db):
            abort(403, _('You are not granted to access this page'))

        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page)

    else:
        return render('project_tab_%s' % page,
                      arec=_arec,
                      page=page)


@subApp.route('/admin/project')
@subApp.route('/admin/project/<act>', method=['GET', 'POST'])
@subApp.route('/admin/project/<act>/<ndx>', method=['GET', 'POST'])
def admin_project(db, act="list", ndx=0):
    """

    :param db:
    """

    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    atmp = request.urlparts.path.split('/')[2]
    apth = "/admin/%s" % atmp
    atbl = Project
    brd = [{"link": apth, "defi": _("Projects")}]

    if request.method == 'GET':

        if act == "list":
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

            arec.is_active = True

            request.session['current_project'] = ""

            return render('%s_edit.tpl' % atmp, arec=arec, breadcumb=brd)

        elif act == "del":
            data = db.query(atbl).filter(atbl.id == ndx).first()
            if not data:
                abort(404, _("No record to delete"))

            request.session['current_project'] = ""

            db.delete(data)
            redirect(apth)
        else:
            abort(404, _('Operation type %s is not supported')% (act, ))

    else:
        #todo: acaba burada Storage(request.POST) mu desek?
        data = request.POST

        #todo: bu kaydetme işlemini jenerik hale getirelim !
        if act == "add":
            arec = atbl()
            db.add(arec)
        else:
            arec = db.query(atbl).filter(atbl.id == ndx).first()

        if act in ['add', 'edit']:
            #Ön tanımlı değerleri verelim
            #Bir de html formu tarafından gönderilmeyen değerleri

            arec.is_active = False
            arec.is_public = False

            formdata_to_sa(data, atbl, arec)

            _pl = request.params.getall('usr_id')
            _rl = request.params.getall('usrrole_id')
            #Önceki kayıtları silelim: todo: daha düzgün yapılmalı bu master-detail işi
            _old = db.query(Project_Usr).filter(Project_Usr.project_id==arec.id)
            _old.delete()
            #yeni kayıtları ekleyelim
            _usrs = []
            for _usr_id in _pl:
                _usr_role_id = _rl[_pl.index(_usr_id)]
                _usr = Project_Usr(usr_id=_usr_id,
                                   project_id=arec.id,
                                   usrrole_id=_usr_role_id)
                _usrs.append(_usr)
            arec.users = _usrs

            try:
                db.commit()
                #todo: burada ileride json dönmeliyiz !

                if (request.session['current_project']):
                    redirect("/project/" + arec.code)
                else:
                    redirect(apth)
            except exc.SQLAlchemyError as err:
                db.rollback()
                abort(500,
                      _("Error in processing DB operation.\nPlease try again! DB Error Msg:\n%s") % err)

@subApp.route('/project_file_upload/<ndx:int>', method=['POST'])
def project_upload(db, ndx):
    cnf = request.app.config

    #todo: yetki kontrolü

    _file = request.POST['afile']

    if _file:
        _file_id, _uuid = upload_file(
            db,
            Upload,
            _file,
            None, #definition
            old_id=None,
            upload_path='%s/uploads/' %cnf['general.base_path'],
            thumb_size=cnf['general.thumb_size'],
            image_size=cnf['general.image_size'],
            store_in_db=cnf['general.store_files_in_db'] == '1'
            )
    else:
        _file_id = 0

    #if upload is succesfull, upload_file function will return uploaded row id !
    if _file_id != 0:
        _upl_row = Project_Upload()
        _upl_row.project_id = ndx
        _upl_row.upload_id = _file_id
        #_upl_row.defi = _fdefi #todo
        db.add(_upl_row)

        try_commit(db)
        return json.dumps({'success': 1, 'message': _('No file uploaded'), 'upload_id': _file_id, 'uuid': str(_uuid)})
    else:
        return json.dumps({'success': 0, 'message': _('No file uploaded')})


@subApp.route('/project_file_delete/<ndx:int>/<file_id:int>', method=['POST'])
def project_delete_file(db, ndx, file_id):
    #todo: project delete file
    pass



@subApp.route('/project_category/<project_id:int>', method=['POST'])
def project_category(db, project_id):
    #todo: check grants

    opr = request.POST.opr

    if opr == 'edit':
        arec = db.query(Project_Category).filter(Project_Category.id == int(request.POST.id)).first()
        if arec:
            arec.code = request.POST.code
            return try_commit(db, True)
        else:
            return json.dumps({"result":False, "message":_('Invalid record to update')})

    elif opr == 'add':
        arec = Project_Category()
        arec.code = request.POST.code
        arec.project_id = project_id
        db.add(arec)
        return try_commit(db, True, arec, 'id')

    elif opr == 'del':
        arec = db.query(Project_Category).filter(Project_Category.id == int(request.POST.id)).first()
        if arec:
            db.delete(arec)
            return try_commit(db, True)
        else:
            return json.dumps({"result":False, "message":_('Invalid record to delete')})
    else:
        return json.dumps({"result":False, "message":_('Unknown crud operation')})



@subApp.route('/project_status/<project_id:int>', method=['POST'])
def project_status(db, project_id):
    #todo: check grants

    opr = request.POST.opr

    if opr == 'edit':
        arec = db.query(Project_Status).filter(Project_Status.id == int(request.POST.id)).first()
        if arec:
            arec.code = request.POST.code
            arec.nro = request.POST.nro
            arec.issue_closed = request.POST.issue_closed

            return try_commit(db, True)
        else:
            return json.dumps({"result":False, "message":_('Invalid record to update')})
    elif opr == 'add':

        arec = Project_Status()
        arec.code = request.POST.code
        arec.project_id = project_id
        arec.nro = request.POST.nro
        arec.issue_closed = request.POST.issue_closed

        db.add(arec)
        return try_commit(db, True, arec, 'id')

    elif opr == 'del':
        arec = db.query(Project_Status).filter(Project_Status.id == int(request.POST.id)).first()
        if arec:
            db.delete(arec)
            return try_commit(db, True)
        else:
            return json.dumps({"result":False, "message":_('Invalid record to delete')})
    else:
        return json.dumps({"result":False, "message":_('Unknown crud operation')})


@subApp.route('/project_milestone/<project_id:int>', method=['POST'])
def project_milestone(db, project_id):
    #todo: check grants

    opr = request.POST.opr

    if opr == 'edit':
        arec = db.query(Project_Milestone).filter(Project_Milestone.id == int(request.POST.id)).first()
        if arec:
            arec.code = request.POST.code
            arec.name = request.POST.name
            dt_plan = request.POST.dt_plan
            #todo: check for valid date !
            if dt_plan:
                arec.dt_plan = request.POST.dt_plan
            arec.is_active = request.POST.is_active
            arec.is_released = request.POST.is_released

            return try_commit(db, True)
        else:
            return json.dumps({"result":False, "message":_('Invalid record to update')})
    elif opr == 'add':

        arec = Project_Milestone()
        arec.project_id = project_id

        arec.code = request.POST.code
        arec.name = request.POST.name

        dt_plan = request.POST.dt_plan
        #todo: check for valid date !
        if dt_plan:
            arec.dt_plan = request.POST.dt_plan
        arec.is_active = request.POST.is_active
        arec.is_released = request.POST.is_released

        db.add(arec)
        return try_commit(db, True, arec, 'id')

    elif opr == 'del':
        arec = db.query(Project_Milestone).filter(Project_Milestone.id == int(request.POST.id)).first()
        if arec:
            db.delete(arec)
            return try_commit(db, True)
        else:
            return json.dumps({"result":False, "message":_('Invalid record to delete')})
    else:
        return json.dumps({"result":False, "message":_('Unknown crud operation')})
