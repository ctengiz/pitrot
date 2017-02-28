# -*- coding: utf-8 -*-

"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 19.12.2013
"""
import datetime
import json

from bottle import Bottle, request, abort, redirect, template
from sqlalchemy import and_, Sequence

from utils_sa import sa_to_dict, formdata_to_sa
from upload import upload_file
from i18n import _
import dbcon
from utils import check_usr_project, list_issue_usr_emails, send_mail,\
    try_commit, decode_config_base64, render, list_issues, \
    get_category_list, get_status_list, get_priority_list, get_milestone_list, \
    is_usr_admin

subApp = Bottle()




def write_changeset(db, issue_id):
    _rec = dbcon.Issue_Changeset()
    _rec.id = db.execute(Sequence('gn_issue_changeset'))
    _rec.issue_id = issue_id
    _rec.usr_id = request.session['usr_id']

    db.add(_rec)

    return _rec.id


def track_issue_changed_fields(db, old_rec, new_rec, changeset=None):
    if old_rec != {}:
        old_rec.pop('id', None)
        old_rec.pop('zlins_usr', None)
        old_rec.pop('zlins_dttm', None)
        old_rec.pop('zlupd_usr', None)
        old_rec.pop('zlupd_dttm', None)
        old_rec.pop('status_nro', None)
        old_rec.pop('priority_nro', None)
        old_rec.pop('issue_closed', None)
        old_rec.pop('last_update', None)
        old_rec.pop('overplan', None)
        old_rec.pop('age', None)
        old_rec.pop('overdue', None)

    _new_rec = sa_to_dict(new_rec, True, False)

    for fld, val in list(old_rec.items()):
        new_val = _new_rec[fld]

        if val == new_val:
            old_rec.pop(fld)
        else:
            if val is None and new_val is None:
                old_rec.pop(fld)

    #Write log vals to db
    if old_rec != {}:
        if not changeset:
            changeset = write_changeset(db, new_rec.id)

        for fld, val in list(old_rec.items()):
            if val is None:
                _val_to_db = None
            else:
                _val_to_db = str(val)

            #print(fld, _val_to_db, str(getattr(new_rec, fld)))

            log_val = dbcon.Issue_Log(issue_id=new_rec.id,
                                      field_name=fld,
                                      old_val=_val_to_db,
                                      new_val=str(getattr(new_rec, fld)),
                                      changeset=changeset)
            db.add(log_val)

    return changeset


def do_file_upload(db, arec, file_ids, file_datas, file_defis, delete_old_file_references=False, changeset=None):
    cnf = request.app.config

    #delete old issue-document relations
    if delete_old_file_references:
        _old = db.query(dbcon.Issue_Upload).filter(dbcon.Issue_Upload.issue_id == arec.id)
        _old.delete()

    #add new issue-document relation records
    _ndx, _jdx = 0, 0
    for _file_id in file_ids:
        _file_id = int(_file_id)
        _fdefi = file_defis[_jdx]

        #if file id is 0, then file does not exist in upload table. So let's upload it
        if _file_id == 0:

            _file = file_datas[_ndx]
            if _file:
                _file_id, _uuid = upload_file(
                    db,
                    dbcon.Upload,
                    _file,
                    _fdefi,
                    old_id=None,
                    upload_path='%s/uploads/' %request.app.config['general.base_path'],
                    thumb_size=cnf['general.thumb_size'],
                    image_size=cnf['general.image_size'],
                    store_in_db=cnf['general.store_files_in_db'] == '1'
                    )
            else:
                _file_id = 0

            _ndx += 1

        #if upload is succesfull, upload_file function will return uploaded row id !
        if _file_id != 0:
            _upl_row = dbcon.Issue_Upload()
            _upl_row.issue_id = arec.id
            _upl_row.upload_id = _file_id
            _upl_row.defi = _fdefi
            _upl_row.changeset = changeset
            db.add(_upl_row)

        _jdx += 1

@subApp.route('/mail_test/<act>/<ndx>')
def send_issue_mail(db, act, arec=None, ndx = 0):

    if ndx != 0:
        arec = db.query(dbcon.Issue).filter(dbcon.Issue.id==ndx).first()

    _old_rec = {}

    if act == 'add':
        subject = _('New Issue: #') + '%s - %s' %(str(arec.id), arec.title)
    else:
        subject = _('Issue Update: #') + '%s - %s' %(str(arec.id), arec.title)

    _mail_template = decode_config_base64(request.app.config['mail.issue_mail'])
    mail_body = template(_mail_template, arec=arec, old_rec=_old_rec, act=act)

    if ndx != 0:
        return mail_body
    else:
        send_mail(list_issue_usr_emails(db, arec.id, arec),
                  subject,
                  mail_body)

@subApp.route('/issue', method=['GET'])
@subApp.route('/issue/list', method=['GET'])
def issue_list(db):

    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    atmp = 'issue'
    apth = "/%s" % atmp
    brd = [{"link": apth, "defi": _("Issues")}]

    cats = get_category_list(db, None)
    stas = get_status_list(db, None)
    prit = get_priority_list(db, None)

    return render('%s_list.tpl' % atmp,
                  alst=list_issues(db),
                  breadcumb=brd,
                  cats=cats,
                  stas=stas,
                  prit=prit
    )

@subApp.route('/issue/<ndx:int>', method=['GET', 'POST'])
@subApp.route('/issue/view/<ndx:int>', method=['GET', 'POST'])
def issue_view(db, ndx=0):
    _prms = request.GET

    arec = db.query(dbcon.Issue).filter(dbcon.Issue.id == ndx).first()

    if arec:
        if not check_usr_project(db, arec.project_id):
            abort(404, _('You are not assigned to this project !'))
        #todo : check for issue owner
        #todo : check if issue is private

    else:
        abort(404, _('No record found'))

    cats = get_category_list(db, arec.project_id)
    stas = get_status_list(db, arec.project_id)
    prit = get_priority_list(db, arec.project_id)
    mile = get_milestone_list(db, arec.project_id)

    brd = [
        {"link": "/project/%s" % arec.project_code, "defi": arec.project_code},
        {"link": "/project/%s/issues" % arec.project_code, "defi": _("Issues")}
    ]

    request.session['current_project'] = arec.project_code

    if request.method == 'GET':
        brd.append({"link": "", "defi": _("View")})

        return render('issue_view.tpl',
                      arec=arec,
                      breadcumb=brd,
                      cats=cats,
                      stas=stas,
                      prit=prit,
                      mile=mile)

    if request.method == 'POST':
        data = request.POST
        if not ('is_private' in data):
            data['is_private'] = False

        #save current record to a dict
        _old_rec = sa_to_dict(arec, True, False)

        formdata_to_sa(data, dbcon.Issue, arec)

        #Clean unchanged and logging info values from old_rec
        changeset = track_issue_changed_fields(db, _old_rec, arec, None)

        #todo : sanitize input:
        if data['comment']:  #fix : should be fixed in upstream : https://github.com/bottlepy/bottle/issues/774
            if not changeset:
                changeset = write_changeset(db, ndx)

            _comment = dbcon.Issue_Comment()
            _comment.issue_id = ndx
            _comment.usr_id = request.session['usr_id']
            _comment.comment = data['comment'] #fix : should be fixed in upstream : https://github.com/bottlepy/bottle/issues/774
            _comment.changeset = changeset
            db.add(_comment)

        #do file uploads
        if not changeset:
            changeset = write_changeset(db, ndx)
        do_file_upload(db,
                       arec,
                       request.params.getall('upload_id'),
                       request.files.getall('picture_load'),
                       request.params.getall('upload_defi'),
                       False, #todo: not sure about this
                       changeset
        )

        #do worklog
        #todo bunu da changelog'a koyalım
        wldata = {}
        for k in data:
            if k[0:3] == 'wl_' and data[k]:
                wldata[k[3:]] = data[k]
        if wldata != {} and 'tm_st' in wldata and 'tm_fn' in wldata and 'dt' in wldata:
            wlrec = dbcon.WorkLog()
            formdata_to_sa(wldata, dbcon.WorkLog, wlrec)
            wlrec.usr_id = request.session['usr_id']
            wlrec.issue_id = arec.id
            wlrec.project_id = arec.project_id
            db.add(wlrec)

        try_commit(db)

        #Send information mail
        send_issue_mail(db, 'edit', arec)

        redirect('/project/%s/issues' % arec.project_code)


@subApp.route('/issue/add', method=['GET', 'POST'])
def issue_add(db):
    """

    :param db:
    """

    _prms = request.GET

    if 'project' in _prms:
        brd = [
            {"link": "/project/%s" % _prms.project, "defi": _prms.project},
            {"link": "/project/%s/issues" % _prms.project, "defi": _("Issues")}
        ]
    else:
        brd = [{"link": "/issue", "defi": _("Issues")}]
    brd.append({"link": "", "defi": 'New'})

    if request.method == 'GET':

        arec = dbcon.Issue()
        arec.id = 0
        arec.usr_code_from = request.session['usr_code']
        arec.usr_id_from = request.session['usr_id']
        arec.dt_open = datetime.date.today()

        #todo: config option !
        arec.status_id = 1
        #todo: config option !
        arec.priority_id = 1

        mile = []

        if 'project' in _prms:
            arec.project_code = _prms.project

            _prj = db.query(dbcon.Project.id).filter(dbcon.Project.code == _prms.project).first()

            if _prj:
                arec.project_id = _prj[0]
                #todo:
                mile = get_milestone_list(db, arec.project_id)
                if not check_usr_project(db, _prj[0]):
                    abort(404, _('You are not assigned to this project !'))
            else:
                abort(404, _('This project does not exists !'))

        cats = get_category_list(db, arec.project_id)
        stas = get_status_list(db, arec.project_id)
        prit = get_priority_list(db, arec.project_id)

        return render('issue_edit.tpl',
                      arec=arec,
                      breadcumb=brd,
                      cats=cats,
                      stas=stas,
                      prit=prit,
                      mile=mile,
                      created_id=_prms.created_id)

    if request.method == 'POST':
        data = request.POST
        if not ('is_private' in data):
            data['is_private'] = False

        arec = dbcon.Issue()
        db.add(arec)
        _old_rec = {}

        formdata_to_sa(data, dbcon.Issue, arec)

        #do uploads!
        do_file_upload(db,
                       arec,
                       request.params.getall('upload_id'),
                       request.files.getall('picture_load'),
                       request.params.getall('upload_defi'),
                       True #todo: not sure about this
        )

        #add watchers list
        new_watchers = []
        if data['watchers']:
            for k in data['watchers'].split(','):
                new_watchers.append(
                    dbcon.Issue_Usr(usr_id=int(k), issue_id=arec.id)
                )

        arec.watchers = new_watchers

        #related issues
        new_rels = []
        _rel_typ = request.params.getall('rel_typ')
        _rel_id = request.params.getall('rel_id')
        for _rid in _rel_id:
            _rtyp = _rel_typ[_rel_id.index(_rid)]
            new_rels.append(
                dbcon.Issue_Rel(issue_id_src=arec.id,
                                issue_id_dst=int(_rid),
                                rel_type=_rtyp)
            )
        arec.rels = new_rels

        try_commit(db)

        send_issue_mail(db, 'add', arec)

        create_and_continue = 'create_and_continue' in data
        request.session['current_project'] = arec.project_code

        if create_and_continue:
            redirect('/issue/add?project=%s&created_id=%d' % (arec.project_code, arec.id))
        else:
            redirect('/project/%s/issues' % arec.project_code)


@subApp.route('/issue/del/<ndx:int>', method=['POST'])
def issue_del(db, ndx):
    rec = db.query(dbcon.Issue).filter(dbcon.Issue.id == ndx).first()
    if rec:
        db.delete(rec)
        return try_commit(db, True)


@subApp.route('/issue_watcher/<ndx:int>', method=['POST'])
def issue_watcher(db, ndx):
    #todo: check granst

    usr_id = int(request.POST['value'])
    opr = request.POST['opr']

    rec = db.query(dbcon.Issue_Usr).filter(and_(dbcon.Issue_Usr.issue_id == ndx,
                                                dbcon.Issue_Usr.usr_id == usr_id)).first()

    if opr == 'add':
        if not rec:
            rec = dbcon.Issue_Usr()

            rec.issue_id = ndx
            rec.usr_id = usr_id
            db.add(rec)

            #todo: try -> commit -> return success or error code
            try_commit(db)
            return json.dumps({'success':1, 'message':'ok', 'usr_code':rec.usr_code, 'usr_id':rec.usr_id})
        else:
            return json.dumps({'success':2})

    if opr == 'del':
        if rec:
            db.delete(rec)

        return try_commit(db, True)


@subApp.route('/issue_comment/<ndx:int>', method=['POST'])
def issue_comment(db, ndx):
    opr = request.POST.opr
    rec = db.query(dbcon.Issue_Comment).filter(dbcon.Issue_Comment.id == ndx).first()
    if rec:
        if opr == 'del':
            db.delete(rec)

        elif opr == 'edt':
            #todo sanitize input !
            rec.comment = request.POST.comment

        return try_commit(db, True)



@subApp.route('/issue_popup', method=['POST'])
def issue_popup(db):
    #todo: check grants

    act = request.POST['act']
    ndx = request.POST['issue_id']
    val = request.POST['val']

    arec = db.query(dbcon.Issue).filter(dbcon.Issue.id == ndx).first()

    if arec:
        #save current record to a dict
        _old_rec = sa_to_dict(arec, True, False)

        if act == 'dt_due':
            arec.dt_due = val
        elif act == 'dt_plan':
            arec.dt_plan = val
            if 'val_fn' in request.POST:
                if request.POST['val_fn']:
                    arec.dt_plan_fn = request.POST['val_fn']
                else:
                    arec.dt_plan_fn = val
        elif act == 'category_id':
            arec.category_id = val
        elif act == 'status_id':
            arec.status_id = val
        elif act == 'priority_id':
            arec.priority_id = val
        elif act == 'usr_id_assigned':
            arec.usr_id_assigned = val
        elif act == 'milestone_id':
            arec.milestone_id = val
        elif act == 'project_id':
            arec.project_id = val
        else:
            return json.dumps({'success':0, 'message':_('Invalid update action')})

        #Clean unchanged and logging info values from old_rec
        changeset = track_issue_changed_fields(db, _old_rec, arec, None)

        rslt = try_commit(db, True)

        #Send information mail
        if json.loads(rslt)['success']:
            send_issue_mail(db, 'edit', arec)

        return rslt
    else:
        return json.dumps({'success':0, 'message':_('No record for update')})


@subApp.route('/issue_rel/<ndx:int>', method=['POST'])
def issue_rel(db, ndx):
    #todo: check granst

    opr = request.POST['opr']

    if opr == 'add':
        rec = dbcon.Issue_Rel()
        rec.issue_id_src = int(request.POST['issue_id_src'])
        rec.issue_id_dst = int(request.POST['issue_id_dst'])
        rec.rel_type = request.POST['rel_type']
        db.add(rec)

        #todo: try -> commit -> return success or error code
        try_commit(db)
        return json.dumps({'success':1, 'message':'ok', 'id':rec.id})

    if opr == 'del':
        rec = db.query(dbcon.Issue_Rel).filter(dbcon.Issue_Rel.id == ndx).first()
        if rec:
            db.delete(rec)
            return try_commit(db, True)
        else:
            return json.dumps({'success': 0, 'message': _('No record to delete')})

