# -*- coding: utf-8 -*-

"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 25.04.2014
"""

import datetime

from bottle import Bottle, request, abort, redirect
from sqlalchemy import desc

from utils_sa import formdata_to_sa
from i18n import _
import dbcon
from utils import check_usr_project, try_commit, render, is_usr_admin

subApp = Bottle()

@subApp.route('/worklog', method=['GET'])
@subApp.route('/worklog/list', method=['GET'])
def worklog_list(db):

    atmp = 'worklog'
    apth = "/%s" % atmp
    brd = [{"link": apth, "defi": _("Worklog")}]

    #todo: filter by user projects
    q = db.query(dbcon.WorkLog)

    #todo more proper grant control
    if not is_usr_admin(db):
        abort(403, _('You are not granted to access this page'))

    alst = q.order_by(desc(dbcon.WorkLog.dt), desc(dbcon.WorkLog.tm_st)).all()

    return render('%s_list.tpl' % atmp, lst=alst, breadcumb=brd)

@subApp.route('/worklog/add', method=['GET', 'POST'])
def worklog_add(db):
    #todo: yetki kontrolü

    _prms = request.GET

    if 'project' in _prms:
        brd = [
            {"link": "/project/%s" % _prms.project, "defi": _prms.project},
            {"link": "/project/%s/worklog" % _prms.project, "defi": _("Worklog")}
        ]
    else:
        brd = [{"link": "/worklog", "defi": _("Worklog")}]

    if request.method == 'GET':
        brd.append({"link": "", "defi": _("New")})
        arec = dbcon.WorkLog()
        arec.id = 0
        arec.usr_id = request.session['usr_id']
        arec.dt = datetime.date.today()

        if 'project' in _prms:
            arec.project_code = _prms.project

            _prj_id = db.query(dbcon.Project.id).filter(dbcon.Project.code == _prms.project).first()

            if _prj_id:
                arec.project_id = _prj_id[0]
                if not check_usr_project(db, _prj_id[0]):
                    abort(404, _('You are not assigned to this project !'))
            else:
                abort(404, _('This project does not exists !'))

        return render('worklog_edit.tpl', arec=arec, breadcumb=brd)

    if request.method == 'POST':
        data = request.POST
        wlrec = dbcon.WorkLog()
        formdata_to_sa(data, dbcon.WorkLog, wlrec)

        if not check_usr_project(db, wlrec.project_id):
            abort(404, _('You are not assigned to this project !'))

        db.add(wlrec)
        try_commit(db)

        if 'project' in _prms:
            redirect('/project/%s/worklog' % request.GET['project'])
        else:
            #todo adminse tüm worklog'u görebilir
            #düz kullanıcı ise kendi sayfasına yönlendirebiliriz
            redirect('/worklog/list')


@subApp.route('/worklog/edit/<ndx:int>', method=['POST', 'GET'])
def worklog_edit(db, ndx):
    #todo: yetki kontrolü
    _prms = request.GET

    if 'project' in _prms:
        brd = [
            {"link": "/project/%s" % _prms.project, "defi": _prms.project},
            {"link": "/project/%s/worklog" % _prms.project, "defi": _("Worklog")}
        ]
    else:
        brd = [{"link": "/worklog", "defi": _("Worklog")}]

    if request.method == 'GET':
        brd.append({"link": "", "defi": _("Edit")})

        arec = db.query(dbcon.WorkLog).filter(dbcon.WorkLog.id == ndx).first()
        if arec:
            if not check_usr_project(db, arec.project_id):
                abort(404, _('You are not assigned to this project !'))
        else:
            abort(404, _('No record found'))

        return render('worklog_edit.tpl', arec=arec, breadcumb=brd)

    if request.method == 'POST':
        data = request.POST
        wlrec = db.query(dbcon.WorkLog).filter(dbcon.WorkLog.id == ndx).first()
        if wlrec:
            formdata_to_sa(data, dbcon.WorkLog, wlrec)
            try_commit(db)

            if 'project' in request.GET:
                redirect('/project/%s/worklog' % request.GET['project'])
            else:
                #todo adminse tüm worklog'u görebilir
                #düz kullanıcı ise kendi sayfasına yönlendirebiliriz
                redirect('/worklog/list')
        else:
            abort(404, _('Worklog record does not exist!'))


@subApp.route('/worklog/del/<ndx:int>', method=['GET'])
def worklog_del(db, ndx):
    #todo: yetki kontrolü
    #todo: projeyi de kontrol edelim. o adam o projede worklog girebiliyor mu?
    #todo: ancak kendi worklogunu silebili
    #todo: veya managerı olduğu worklog'u silebilir
    #todo: bunun için global bir yetki prosedürü tanımlanmalı


    data = db.query(dbcon.WorkLog).filter(dbcon.WorkLog.id == ndx).first()
    if not data:
        abort(404, _("No record to delete"))

    db.delete(data)
    try_commit(db)

    if 'project' in request.GET:
        redirect('/project/%s/worklog' % request.GET['project'])
    else:
        redirect('/worklog/list')


