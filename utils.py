"""
Helper functions

__author__ : Çağatay Tengiz
__date__   : 25.12.2013
"""

import datetime

import json
import configparser
import base64
import logging
import re

from bottle import template
from sqlalchemy import exc
from sqlalchemy.sql.expression import label
from bottle import abort

from dbcon import *
import utils_mailing
from i18n import _


def try_commit(db, return_json=False, result_rec=None, result_fields=[], ok_message="ok"):
    """
    try to commit transction, on exception rollback and abort
    """

    _result_vals = {}

    try:
        db.commit()

        if isinstance(result_fields, str):
            result_fields = result_fields.split(',')
        for _fld in result_fields:
            _result_vals[_fld] = getattr(result_rec, _fld)

        if return_json:
            _result_vals['success'] = 1
            _result_vals['message'] = ok_message
            return json.dumps(_result_vals)
        else:
            return True

    except exc.SQLAlchemyError as err:
        db.rollback()

        logging.error('try_commit err: %s' % str(err))

        if return_json:
            _result_vals['success'] = 0
            _result_vals['message'] = str(err)
            return json.dumps(_result_vals)
        else:
            abort(500, _("Error in processing DB operation.\nPlease try again! DB Error Msg:\n%s") % str(err))


def init_session():
    s = request.environ.get('beaker.session')
    s['usr_code'] = None
    s['logged_in'] = False
    s['is_admin'] = False
    s['usr_id'] = False
    s['user_projects'] = []
    s['path'] = '/'
    s['current_project'] = ''
    s.save()


def is_usr_admin(db, usr_id=None):
    if not usr_id:
        usr_id = request.session['usr_id']
        return request.session['is_admin']
    else:
        ausr = db.query(Usr.is_admin).filter(Usr.id == usr_id).first()

        if ausr:
            return ausr[0]
        else:
            return False


def check_usr_project(db, project_id, usr_id=None):
    if not usr_id:
        usr_id = request.session['usr_id']

    prj_id = db.query(Project.id).filter(
        and_(Project.id == project_id,
             or_(Project.is_public==1,
                 exists().where(
                     and_(Project_Usr.usr_id == usr_id,
                          Project_Usr.project_id == Project.id)
                 )
             )
        )
    ).first()

    return prj_id or is_usr_admin(db, usr_id)


def check_usr_client(db, client_id, usr_id=None):
    if not usr_id:
        usr_id = request.session['usr_id']

    client_id = db.query(Client.id).filter(
        or_(
            and_(Client.id == db.query(Usr.client_id).filter(Usr.id == usr_id).as_scalar(),
                 Client.id == client_id),

            Client.id.in_(
                db.query(
                    Project.client_id
                ).filter(
                    or_(Project.is_public==1,
                        exists().where(
                            and_(Project_Usr.usr_id == usr_id,
                                 Project_Usr.project_id == Project.id))
                    )
                )
            )
        )
    ).first()

    return client_id or is_usr_admin(db, usr_id)


def list_usr_projects(db, usr_id=None):
    if not usr_id:
        usr_id = request.session['usr_id']

    prj = db.query(Project).filter(
        or_(Project.is_public == 1,
            exists().where(
                and_(Project_Usr.usr_id == usr_id,
                     Project_Usr.project_id == Project.id
                )
            )
        )).order_by(Project.code).all()
    return prj


def list_usr_opened_issues(db, usr_id=None, filter_closed=False, rows=10):
    if not usr_id:
        usr_id = request.session['usr_id']

    _issue = db.query(Issue).filter(Issue.usr_id_from == usr_id).order_by(desc(Issue.dt_open), desc(Issue.id))
    if filter_closed:
        _issue = _issue.filter(Issue.issue_closed == 0)

    return _issue.limit(rows)


def list_usr_assigned_issues(db, usr_id=None, filter_closed=False, rows=10):
    if not usr_id:
        usr_id = request.session['usr_id']

    _issue = db.query(Issue).filter(Issue.usr_id_assigned == usr_id).order_by(desc(Issue.dt_open), desc(Issue.id))

    if filter_closed:
        _issue = _issue.filter(Issue.issue_closed == 0)

    return _issue.limit(rows)


def list_last_updates(db, usr_id=None, project_id=None, client_id=None, rows=10):
    #todo: filter private issues
    #todo: filter user pojects

    #New created issues
    qr_new = db.query(label('issue_id', Issue.id),
                      label('project_id', Issue.project_id),
                      label('dttm', Issue.zlins_dttm),
                      label('usr_id', Issue.usr_id_from),
                      label('update_type', literal_column("'issue_new'")),
                      label('rel_id', Issue.id),
                      literal_column("Null").label("uuid")
    ).filter(~exists().where(Issue_Log.issue_id == Issue.id))

    #Updated issues
    qr_update = db.query(label('issue_id', Issue.id),
                         label('project_id', Issue.project_id),
                         label('dttm', Issue_Changeset.zlins_dttm),
                         label('usr_id', Issue_Changeset.usr_id),
                         label('update_type', literal_column("'issue_update'")),
                         label('rel_id', Issue_Changeset.id),
                         literal_column("Null").label("uuid")
    ).\
        join(Issue_Changeset, Issue_Changeset.issue_id == Issue.id).\
        filter(~exists().where(Issue_Comment.changeset == Issue_Changeset.id)).\
        filter(~exists().where(Issue_Upload.changeset == Issue_Changeset.id))

    #Comment
    qr_comment = db.query(label('issue_id', Issue.id),
                          label('project_id', Issue.project_id),
                          label('dttm', Issue_Comment.zlins_dttm),
                          label('usr_id', Issue_Comment.usr_id),
                          label('update_type', literal_column("'issue_comment'")),
                          label('rel_id', Issue_Comment.id),
                          literal_column("Null").label("uuid")
    ).join(Issue_Comment, Issue_Comment.issue_id == Issue.id)

    #Worklog
    qr_worklog = db.query(label('issue_id', WorkLog.issue_id),
                          label('project_id', WorkLog.project_id),
                          label('dttm', WorkLog.zlins_dttm),
                          label('usr_id', WorkLog.usr_id),
                          label('update_type', literal_column("'worklog'")),
                          label('rel_id', WorkLog.id),
                          literal_column("Null").label("uuid")
    )

    #Issue Upload
    qr_iupload = db.query(label('issue_id', Issue_Upload.issue_id),
                          db.query(Issue.project_id).filter(Issue.id == Issue_Upload.issue_id).label("project_id"),
                          label('dttm', Issue_Upload.zlins_dttm),
                          label('usr_id', Issue_Upload.zlins_usr),
                          label('update_type', literal_column("'issue_upload'")),
                          label('rel_id', Issue_Upload.changeset),
                          db.query(Upload.uuid).filter(Upload.id == Issue_Upload.upload_id).label("uuid")
    ).filter(Issue_Upload.changeset != None)

    #Project Upload
    qr_pupload = db.query(label('issue_id', literal_column("Null")),
                          Project_Upload.project_id.label('project_id'),
                          label('dttm', Project_Upload.zlins_dttm),
                          label('usr_id', Project_Upload.zlins_usr),
                          label('update_type', literal_column("'project_upload'")),
                          label('rel_id', Project_Upload.upload_id),
                          db.query(Upload.uuid).filter(Upload.id == Project_Upload.upload_id).label("uuid")
    )

    #Wiki Changes
    #todo: wiki changes

    qu = union(qr_new, qr_update, qr_comment, qr_worklog, qr_iupload, qr_pupload).alias('s')

    q = db.query(qu,
                 db.query(Project.code).filter("Project.id = s.project_id").label("project_code"),
                 db.query(Usr.code).filter("Usr.id = s.usr_id").label("usr_code"),
                 db.query(Issue.title).filter("Issue.id = s.issue_id").label("title"),
                 db.query(Upload.file_name).filter("Upload.uuid = s.uuid").label("file_name"),
                 )\

    if project_id:
        q = q.filter("s.project_id = %s" %project_id)

    if usr_id:
        q = q.filter("s.usr_id = %s" %usr_id)

    if client_id:
        q = q.filter("(select p.client_id from project p where p.id = s.project_id) = :client_id").\
            params(client_id=client_id)

    #Filter for ordinary users projects
    if not is_usr_admin(db):
        q = q.filter(or_("s.project_id in (select project_id from project_usr where project_usr.usr_id = %s)" % request.session["usr_id"],
                         "(select is_public from project px where px.id=s.project_id) = 1"))

    q = q.order_by(desc("s.dttm")).limit(rows).all()

    return q


def list_project_usrs(db, project_id):
    _is_public = db.query(Project.is_public).filter(Project.id == project_id).first()[0]

    if _is_public:
        return db.query(Usr.code, Usr.id).filter(Usr.statu == 1).all()
    else:
        qry = db.query(Usr.code, Usr.id).filter(Usr.id.in_(
            db.query(Project_Usr.usr_id).filter(Project_Usr.project_id == project_id)
        )).filter(Usr.statu == 1).all()

        return qry


def list_issues(db, project_id=None, usr_id=None, client_id=None, usr_id_from=None, usr_id_watch=None):
    _prms = request.GET

    alst = db.query(Issue).filter(or_(Issue.is_private == 0,
                                      and_(Issue.is_private == 1,
                                           Issue.usr_id_from == request.session['usr_id'])))

    if project_id:
        alst = alst.filter(Issue.project_id == project_id)
    if usr_id:
        alst = alst.filter(Issue.usr_id_assigned == usr_id)
    if usr_id_from:
        alst = alst.filter(Issue.usr_id_from == usr_id_from)
    if usr_id_watch:
        alst = alst.filter(exists().where(and_(Issue_Usr.usr_id == usr_id_watch, Issue_Usr.issue_id==Issue.id)))
    if client_id:
        alst = alst.filter("(select p.client_id from project p where p.id = issue.project_id) = :client_id").\
            params(client_id=client_id)

    if not('status' in _prms):
        _prms['status'] = 'active'
    if 'status_id' in _prms or 'status_code' in _prms:
        _prms['status'] = 'all'

    if _prms.status == 'active':
        alst = alst.filter(Issue.issue_closed == False)
    elif _prms.status == 'closed':
        alst = alst.filter(Issue.issue_closed == True)

    if 'status_id' in _prms:
        alst = alst.filter(Issue.status_id == _prms['status_id'])

    if 'status_code' in _prms:
        alst = alst.filter(Issue.status == _prms.status_code)

    if 'ck_unassigned' in _prms:
        alst = alst.filter(Issue.usr_id_assigned == None)

    if 'ck_unplanned' in _prms:
        alst = alst.filter(Issue.dt_plan == None)

    if 'ck_noduedate' in _prms:
        alst = alst.filter(Issue.dt_due == None)

    if 'ck_overdue' in _prms:
        alst = alst.filter('Issue.dt_due <= current_date')

    if 'ck_overplan' in _prms:
        alst = alst.filter('Issue.dt_plan <= current_date')

    _usrid = request.session['usr_id']
    if 'ausr' in _prms:
        _usrid = int(_prms['ausr'])

    if 'ck_assignedtome' in _prms:
        alst = alst.filter(Issue.usr_id_assigned == _usrid)

    if 'ck_openedbyme' in _prms:
        alst = alst.filter(Issue.usr_id_from == _usrid)

    if 'ck_watchedbyme' in _prms:
        alst = alst.filter(exists().where(Issue_Usr.usr_id == _usrid))

    if 'usr_id_assigned' in _prms:
        alst = alst.filter(Issue.usr_id_assigned == _prms['usr_id_assigned'])

    if 'milestone_id' in _prms:
        alst = alst.filter(Issue.milestone_id == _prms['milestone_id'])

    if 'category_id' in _prms:
        alst = alst.filter(Issue.category_id == _prms['category_id'])

    if 'priority_id' in _prms:
        alst = alst.filter(Issue.priority_id == _prms['priority_id'])

    alst = alst.order_by(desc(Issue.dt_open)).all()

    return alst


def list_issue_usr_emails(db, issue_id, arec=None):
    logging.debug('mail hesapları seçim başlangıcı')

    email_list = []
    if not arec:
        arec = db.query(Issue).filter(id == issue_id).first()

    if not arec:
        return email_list

    #Get email of issue reporter
    if request.session['self_notification']:
        q = db.query(Usr.email).filter(Usr.id == arec.usr_id_from).first()
        if q:
            if q.email:
                email_list.append(q.email)

    #Get email of assignee
    q = db.query(Usr.email).filter(Usr.id == arec.usr_id_assigned).first()
    if q:
        if q.email:
            email_list.append(q.email)

    #Get emails of watchers
    q = db.query(Issue_Usr.usr_id, Usr.email).\
        join(Usr, Usr.id == Issue_Usr.usr_id).\
        filter(and_(Issue_Usr.issue_id == issue_id,
                    Usr.ck_notification_watcher == 1)).\
        all()
    for rw in q:
        if rw.email:
            email_list.append(rw.email)

    #Get emails of project members
    q = db.query(Project_Usr.usr_id, Usr.email).\
        join(Usr, Usr.id == Project_Usr.usr_id).\
        filter(and_(Project_Usr.project_id == arec.project_id,
                    Usr.ck_notification_project == 1)).\
        all()
    for rw in q:
        if rw.email:
            email_list.append(rw.email)

    #Get emails for public project subscribers
    q = db.query(Project_Usr.usr_id, Usr.email).\
        join(Usr, Usr.id == Project_Usr.usr_id).\
        join(Project, Project.id == Project_Usr.project_id).\
        filter(and_(Project_Usr.project_id == arec.project_id,
                    Usr.ck_notification_project == 1)).\
        all()
    for rw in q:
        if rw.email:
            email_list.append(rw.email)

    #get a unique list. not sure if this is the best way to do it.
    email_list = list(set(email_list))

    #last check if reporters / updaters self notification
    if not(request.session['self_notification']):
        if request.session['usr_email'] in email_list:
            email_list.remove(request.session['usr_email'])

    logging.debug('mail hesapları seçim sonucu')

    return email_list


def get_category_list(db, project_id):
    return db.query(Project_Category).filter(Project_Category.project_id==project_id).\
        order_by(Project_Category.code).all()


def get_milestone_list(db, project_id):
    return db.query(Project_Milestone).filter(Project_Milestone.project_id==project_id).\
        order_by(Project_Milestone.code).all()


def get_status_list(db, project_id):
    return db.query(Project_Status).filter(Project_Status.project_id==project_id).\
        order_by(Project_Status.nro).all()


def get_priority_list(db, project_id):
    return db.query(DfIssuePriority).order_by(DfIssuePriority.nro).all()
    #todo:
    """
    return db.query(Project_Priority).filter(Project_Priority.project_id==project_id).\
        order_by(Project_Priority.code).all()
    """


def send_mail(msg_to, subject, msg_body, cnf=None):
    if not(cnf):
        cnf = request.app.config

    '''
    if cnf['general.debugging_on'] == '1':
        logging.basicConfig(filename='%s/debug.log' % os.path.abspath(os.path.dirname(__file__)),
                            format='%(asctime)s %(levelname)s %(message)s',
                            level=logging.DEBUG,
                            filemode="w")
    '''

    logging.debug('mail gönderim başlangıcı')

    if cnf['general.test_run'] == '1':
        pass
    else:
        if msg_to:
            logging.debug('gönderim hesapları: %s' % ', '.join(msg_to))
            utils_mailing.send_mail(
                cnf['mail.address'],
                msg_to,
                subject,
                msg_body,
                msg_from_name=cnf['mail.from'],
                msg_attach=[],
                smtp_server=cnf['mail.server'],
                smtp_port=cnf['mail.port'],
                smtp_user=cnf['mail.login'],
                smtp_pass=cnf['mail.password'],
                smtp_do_auth=True,
                smtp_start_tls=cnf['mail.start_tls']
            )
            logging.debug('fiilen mail gitti')

    if cnf['general.debugging_on'] == '1':
        logging.debug('mail gönderim bitişi')


def read_config_file(path):
    aconfig = configparser.ConfigParser()
    with open('%s/config.ini' % path, 'r', encoding='utf-8') as f:
        aconfig.read_file(f)

    return aconfig


def decode_config_base64(decoded_string):
    return base64.b64decode(decoded_string.encode("ascii")[2:-1]).decode("utf-8")


def render(*args, **kwargs):
    _dr = request.app.config['general.base_path']
    _tm = request.app.config['general.template']
    _ll = '%s/views/%s/' %(_dr, _tm)

    kwargs['template_lookup'] = [_ll]
    return template(*args, **kwargs)


def format_datetime_for_cal(dttm):
    if dttm:
        return dttm.strftime('%Y-%m-%d %H:%M')
    else:
        return ''


def render_comment(comment):

    if not comment:
        return ''

    db = scoped_session(sessionmaker(bind=engine))

    #change issue refs to hrefs
    p = re.compile(r"#\d+")
    iterator = p.finditer(comment)
    for match in iterator:
        _issue_id = match.group()[1:]
        q = db.query(Issue).filter(Issue.id == _issue_id).first()
        if q:
            _href = '<a href="/issue/%d?project=%s">%s</a>' %(q.id, q.project_code, match.group())
            comment = comment.replace(match.group(), _href, 1)

    #change user refs to hrefs
    #source : http://stackoverflow.com/questions/2304632/regex-for-twitter-username
    p = re.compile(r"(?<=^|(?<=[^a-zA-Z0-9-_\\.]))@([A-Za-z]+[A-Za-z0-9_\\.]+)")
    iterator = p.finditer(comment)
    for match in iterator:
        _usr_code = match.group()[1:]
        #todo: burası çok çakma oldu
        #hatayı tekrar üretmek için :
        try:
            q = db.query(Usr).filter(Usr.code == _usr_code).first()
            if q:
                _href = '<a href="/user/%d">%s</a>' %(q.id, match.group())
                comment = comment.replace(match.group(), _href, 1)
        except Exception as e:
            print(e)

    #html commentlerde saçmalıyor bu !
    """
    p = re.compile(r"([a-zA-Z]+\://)?([a-zA-Z0-9\-\.]*\.+[a-zA-Z]*)(:(6553[0-5]|655[0-2]\d|65[0-4]\d{2}|6[0-4]\d{3}|5\d{4}|[0-9]\d{0,3}))?(/([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~]*)[^\.\,\)\(\s]?)?")
    iterator = p.finditer(comment)
    for match in iterator:
        _grp = match.group()
        _href = '<a href="%s" target="_blank">%s</a>' %(_grp, _grp)
        comment = comment.replace(_grp, _href, 1)
    """

    return comment


def is_numeric(aval):
    """Checks via type() if aval is numeric or not.

    :param aval:
    :return: :boolean:
    """
    atyp = type(aval)
    if (atyp == datetime.datetime
        or atyp == datetime.time
        or atyp == datetime.date
        or atyp == int
        or atyp == float
        or atyp == complex
    ):
        return True
    else:
        return False


def is_string_numeric(aval, ignore_empty_string=True):
    """Checks if a string contains a numeric value

    :param aval:
    :param ignore_empty_string: If `True`, empt string will be tretaed as if it contains 0
    :return: :rtype:
    """
    if aval == '' or aval == '' and ignore_empty_string:
        return True
    try:
        float(aval)
        return True
    except ValueError:
        return False


def datetime_to_str(dt):
    """Converts a date/time value to string.

    :param dt:
    :return: :rtype:
    """

    _typ = type(dt)

    #todo: get format from locale settings
    if _typ == datetime.date:
        return dt.strftime('%d.%m.%Y')

    elif _typ == datetime.datetime:
        return dt.strftime('%d.%m.%Y %H:%M')

    elif _typ == datetime.time:
        return dt.strftime('%H:%M')

    else:
        return None


def current_year():
    return datetime.datetime.today().year


def current_month():
    return datetime.datetime.today().month


def current_date_as_str():
    dt = datetime.date.today()
    return dt.strftime('%d.%m.%Y')