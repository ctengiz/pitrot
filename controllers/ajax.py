"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 07.01.2014
"""

import json

from sqlalchemy import and_, or_, exists
from bottle import Bottle, request

import dbcon
import utils
from utils_sa import sa_to_json

subApp = Bottle()


@subApp.route('/ajax/<act>', method=['GET', 'POST'])
@subApp.route('/ajax/<act>/', method=['GET', 'POST'])
def ajax(db, act):
    flt = request.POST
    qry = None

    if act == 'client':
        qry = db.query(dbcon.Client.code, dbcon.Client.id).order_by(dbcon.Client.code).all()

    elif act == 'project':
        q = db.query(dbcon.Project.code, dbcon.Project.id)

        if not utils.is_usr_admin(db):
            q = q.filter(or_(dbcon.Project.is_public == 1,
                             exists().where(
                                 and_(dbcon.Project_Usr.usr_id == int(request.session['usr_id']),
                                      dbcon.Project_Usr.project_id == dbcon.Project.id)

                             )))

        q = q.filter(dbcon.Project.is_active == 1)

        qry = q.order_by(dbcon.Project.code).all()

    elif act == 'usrrole':
        qry = db.query(dbcon.UsrRole.code, dbcon.UsrRole.id).order_by(dbcon.UsrRole.code).all()

    elif act == 'usrgrp':
        qry = db.query(dbcon.UsrGrp.code, dbcon.UsrGrp.id).order_by(dbcon.UsrGrp.code).all()

    elif act == 'usr':
        _project_id = flt.project_id if 'project_id' in flt else None

        if _project_id:
            qry = utils.list_project_usrs(db, _project_id)
        else:
            qry = db.query(dbcon.Usr.code, dbcon.Usr.id).filter(dbcon.Usr.statu == 1).order_by(dbcon.Usr.code).all()

    elif act == 'issue':
        _project_id = flt.project_id if 'project_id' in flt else None

        if _project_id:
            qry = db.query(dbcon.Issue.title.label('code'),
                           dbcon.Issue.id).\
                filter(and_(dbcon.Issue.project_id == _project_id,
                            or_(dbcon.Issue.is_private == 0,
                                and_(dbcon.Issue.is_private == 1,
                                     dbcon.Issue.usr_id_from == request.session['usr_id'])))).\
                order_by(dbcon.Issue.title).all()
        else:
            qry = db.query(dbcon.Issue.title.label('code'),
                           dbcon.Issue.id).\
                filter(or_(dbcon.Issue.is_private == 0,
                           and_(dbcon.Issue.is_private == 1,
                                dbcon.Issue.usr_id_from == request.session['usr_id']))).\
                order_by(dbcon.Issue.title).all()

    elif act == 'milestone':
        #todo: #550
        qry = db.query(dbcon.Project_Milestone.code,
                       dbcon.Project_Milestone.id).\
            filter(and_(dbcon.Project_Milestone.id == flt['project_id'],
                        dbcon.Project_Milestone.is_active == 1)).\
            order_by(dbcon.Project_Milestone.code).all()

    if qry:
        return sa_to_json(qry)

@subApp.route('/get_cal_events', method=['GET', 'POST'])
def get_cal_events(db):
    flt = request.POST
    #_dttm_st = datetime.datetime.fromtimestamp(int(flt['start'])).strftime('%d.%m.%Y')
    #_dttm_fn = datetime.datetime.fromtimestamp(int(flt['end'])).strftime('%d.%m.%Y')

    qry = db.query(dbcon.Issue).\
        filter(and_(or_(dbcon.Issue.is_private == 0, dbcon.Issue.usr_id_from == request.session['usr_id']),
                    dbcon.Issue.dt_plan != None,
                    dbcon.Issue.dt_plan >= flt['start'],
                    dbcon.Issue.dt_plan <= flt['end'],
                    dbcon.Issue.issue_closed == False
                    ))

    if 'project_id' in flt:
        if flt['project_id']:
            qry = qry.filter(dbcon.Issue.project_id == flt['project_id'])

    if 'usr_id' in flt:
        if flt['usr_id']:
            qry = qry.filter(dbcon.Issue.usr_id_assigned == flt['usr_id'])

    if 'client_id' in flt:
        if flt['client_id']:
            qry = qry.filter(dbcon.Issue.client_id == flt['client_id'])

    qry = qry.all()

    rslt = []

    for k in qry:

        _title = '%s <br/> %s-%d <br/> [%s]' %(k.project_code, k.title, k.id, k.usr_code_assigned)
        _description = utils.render('_calendar_event_description', arec=k)

        _url = '/issue/%d' % k.id

        _rw = {'title': _title,
               'start': utils.format_datetime_for_cal(k.dt_plan),
               'end': utils.format_datetime_for_cal(k.dt_plan_fn),
               'id': k.id,
               'url': _url,
               'allDay': True,
               'description': _description}

        rslt.append(_rw)

    return json.dumps(rslt)


