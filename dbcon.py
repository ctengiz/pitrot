"""
Modülün Açıklaması

__author__ : Çağatay Tengiz
__date__   : 15.11.2013
"""

import datetime

from sqlalchemy import *
from sqlalchemy import func
from sqlalchemy.ext.declarative import \
    declared_attr,\
    declarative_base, \
    DeferredReflection
from sqlalchemy.orm import \
    sessionmaker, \
    scoped_session, \
    column_property, \
    relationship, \
    deferred, \
    events, \
    object_session, \
    backref


from bottle import request

from i18n import _

Base = declarative_base()

engine = None
plugin_sqlalchemy = None

revision = '$Revision$'


def init_sa(conf):
    global engine
    global plugin_sqlalchemy

    engine = create_engine('firebird+fdb://%s:%s@%s/%s/%s?charset=UTF8' %
                           (
                               conf['database.db_user'],
                               conf['database.db_pass'],
                               conf['database.db_server'],
                               conf['database.db_path'],
                               conf['database.db_name']
                           ),
                           echo=conf['database.echo_sqlalchemy'] == '1',
                           retaining=True,
                           enable_rowcount=False
                           )

    """
    engine = create_engine('mysql+mysqldb://root:@127.0.0.1:3306/pitrot?charset=utf8',
                           echo=conf['database.echo_sqlalchemy'] == '1')
    """

    Base.metadata.bind = engine

    from bottle.ext import sqlalchemy
    plugin_sqlalchemy = sqlalchemy.Plugin(
        engine,  # SQLAlchemy engine created with create_engine function.
        Base.metadata,  # SQLAlchemy metadata, required only if create=True.
        keyword='db',  # Keyword used to inject session database in a route (default 'db').
        create=False,  # If it is true, execute `metadata.create_all(engine)` when plugin is applied (default False).
        commit=True,  # If it is true, plugin commit changes after route is executed (default True).
        use_kwargs=False  # If it is true and keyword is not defined, plugin uses **kwargs argument to inject session database (default False).
)



class MkMixin(object):
    @declared_attr
    def __tablename__(cls):
        return cls.__name__.lower()

    zlins_dttm = Column(DateTime, default=func.now())
    zlupd_dttm = Column(DateTime, onupdate=func.now())
    zlins_usr = Column(BigInteger)
    zlupd_usr = Column(BigInteger)

    zlins_dttm._creation_order = 9990
    zlins_usr._creation_order = 9991
    zlupd_dttm._creation_order = 9992
    zlupd_usr._creation_order = 9993


    @staticmethod
    def create_usr(mapper, connection, target):
        if 'beaker.session' in request.environ:
            target.zlins_usr = request.environ['beaker.session']['usr_id']

    @staticmethod
    def update_usr(mapper, connection, target):
        if 'beaker.session' in request.environ:
            target.zlupd_usr = request.environ['beaker.session']['usr_id']

    @classmethod
    def __declare_last__(cls):

        # get called after mappings are completed
        # http://docs.sqlalchemy.org/en/rel_0_7/orm/extensions/declarative.html#declare-last
        events.event.listen(cls, 'before_insert', cls.create_usr)
        events.event.listen(cls, 'before_update', cls.update_usr)

    __table_args__ = {'autoload': False,  # Bu seçenek true olursa, veritabanından otomatik yüklemeye çalışıyor...
                       'extend_existing': True}
    #__mapper_args__= {'exclude_properties': ['cnt_bin', 'cnt_thb']}  #'always_refresh': True}


class Config(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_config'), primary_key=True)
    code = Column(String(30))
    defi = Column(String(200))
    cval = Column(String(200))


class Usr(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_usr'), primary_key=True)
    code = Column(String(30), nullable=False, unique=True)
    upass = Column(String(30))
    email = Column(String(50), nullable=False, unique=True)

    full_name = Column(String(50))

    is_admin = Column(Boolean, default=False, nullable=False)

    #authentication method
    #   0: Password
    #   1: Auth through active directory
    auth_method = Column(SmallInteger, default=0)
    dc_name = Column(String(20))

    client_id = Column(BigInteger, ForeignKey("client.id",
                                              onupdate="CASCADE",
                                              ondelete="CASCADE",
                                              name="fk_usr_client"))

    client_code = column_property(select([literal_column('Client.code')],
                                         from_obj=text('Client')).where(text('Client.id=Usr.client_id')))

    projects = relationship('Project_Usr',
                            backref='b_projects_usr',
                            primaryjoin=('Usr.id==Project_Usr.usr_id'))

    worklog = relationship('WorkLog',
                           backref='b_usr_worklog',
                           order_by=[desc('WorkLog.dt')],
                           primaryjoin='Usr.id==WorkLog.usr_id',
                           cascade="all, delete-orphan")

    statu = Column(SmallInteger, default=1)
    ck_notification_self = Column(Boolean, default=False)
    ck_notification_watcher = Column(Boolean, default=False)
    ck_notification_project = Column(Boolean, default=False)
    ck_notification_public_project = Column(Boolean, default=False)

    usrrole_id = Column(BigInteger, ForeignKey("usrrole.id",
                                               onupdate="CASCADE",
                                               ondelete="NO ACTION",
                                               name="fk_usr_usrrole"))
    usrrole_code = column_property(select([literal_column('UsrRole.code')],
                                          from_obj=text('UsrRole')).where(text('UsrRole.id=Usr.usrrole_id')))

    hourly_wage = Column(Numeric)
    hourly_wage_crn = Column(String(3))

    @property
    def statu_def(self):
        if self.statu == 1:
            return _('Active')
        elif self.statu == 2:
            return _('Waiting Email Conf.')
        elif self.statu == 3:
            return _('Waiting Admin Conf.')
        elif self.statu == 99:
            return _('Disabled')


class UsrRole(Base, MkMixin):
    id = Column(BigInteger, Sequence("gn_usrrole"), primary_key=True)
    code = Column(String(30), unique=True, nullable=False)


class UsrGrp(Base, MkMixin):
    id = Column(BigInteger, Sequence("gn_usrgrp"), primary_key=True)
    code = Column(String(30), unique=True, nullable=False)

    members = relationship('UsrGrp_Usr',
                           backref="b_usrgrp",
                           primaryjoin="UsrGrp_Usr.usrgrp_id==UsrGrp.id",
                           cascade="all, delete-orphan")


class UsrGrp_Usr(Base, MkMixin):
    id = Column(BigInteger, Sequence("gn_usrgrp_usr"), primary_key=True)

    usr_id = Column(BigInteger, ForeignKey("usr.id",
                                           onupdate="CASCADE",
                                           ondelete="CASCADE",
                                           name="fk_usrgrp_usr_usr"),
                    nullable=False)
    usr_code = column_property(select([literal_column('Usr.code')],
                                      from_obj=text('Usr')).where(text('Usr.id=UsrGrp_Usr.usr_id')))

    usrgrp_id = Column(BigInteger, ForeignKey("usrgrp.id",
                                              onupdate="CASCADE",
                                              ondelete="CASCADE",
                                              name="fk_usrgrp_usr_usrgrp"),
                       nullable=False)
    usrgrp_code = column_property(select([literal_column('UsrGrp.code')],
                                         from_obj=text('UsrGrp')).where(text('UsrGrp.id=UsrGrp_Usr.usrgrp_id')))

    __table_args__ = (UniqueConstraint('usr_id', 'usrgrp_id', name='uq_usrgrp_usr_1'), MkMixin.__table_args__)


class DfLang(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_dflang'), primary_key=True)
    code = Column(String(2), unique=True, nullable=False)
    defi = Column(String(50))


class DfTag(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_dftag'), primary_key=True)
    code = Column(String(30))


class DfIssueCategory(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_dfissuecategory'), primary_key=True)
    code = Column(String(30), unique=True)


class DfIssuePriority(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_dfissuepriority'), primary_key=True)
    code = Column(String(30), unique=True)
    nro = Column(Integer, nullable=False)


class DfIssueStatus(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_dfissuestatus'), primary_key=True)
    code = Column(String(30), unique=True)
    nro = Column(Integer, nullable=False, default=0)
    issue_closed = Column(Boolean, default=False, nullable=False)


class DfIssueSeverity(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_dfissueseverity'), primary_key=True)
    code = Column(String(30), unique=True)


class Client(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_client'), primary_key=True)
    code = Column(String(30), unique=True, nullable=False)
    name = Column(String(200))

    users = relationship('Usr',
                         backref='b_client_usr',
                         order_by=[asc('Usr.code')],
                         primaryjoin='Client.id==Usr.client_id',
                         cascade="all, delete-orphan"
    )

    projects = relationship('Project',
                            backref='b_client_project',
                            order_by=[asc('Project.code')],
                            primaryjoin='Client.id==Project.client_id',
                            cascade="all, delete-orphan"
                            )


class Project(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_project'), primary_key=True)
    parent_id = Column(BigInteger,ForeignKey("project.id",
                                             ondelete="CASCADE",
                                             onupdate="CASCADE",
                                             name="fk_project_parent"))
    parent_code = column_property(select([literal_column('p.code')],
                                         from_obj=text('Project p')).where(text('p.id=Project.parent_id')))

    code = Column(String(30), unique=True, nullable=False)
    name = Column(String(200))

    is_public = Column(Boolean, default=False, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)

    client_id = Column(BigInteger, ForeignKey("client.id",
                                              onupdate="CASCADE",
                                              ondelete="CASCADE",
                                              name="fk_project_client"))

    client_code = column_property(select([literal_column('Client.code')],
                                         from_obj=text('Client')).where(text('Client.id=Project.client_id')))
    client_name = column_property(select([literal_column('Client.name')],
                                         from_obj=text('Client')).where(text('Client.id=Project.client_id')))

    dt_start = Column(Date)
    dt_finish = Column(Date)

    notes = Column(TEXT)

    #todo: danışman bazında değişebilir yapalım
    hourly_rate = Column(Numeric)
    hourly_rate_crn = Column(String(3))

    issues = relationship('Issue',
                          backref='b_issue_project',
                          primaryjoin=('Project.id==Issue.project_id'),
                          order_by=[desc('Issue.id')],
                          cascade="all, delete-orphan"
                          )

    users = relationship('Project_Usr',
                         backref='b_project_usr_project',
                         order_by=[asc('Project_Usr.usr_id')],
                         primaryjoin='Project.id==Project_Usr.project_id',
                         cascade="all, delete-orphan"
    )

    uploads = relationship('Project_Upload',
                           backref='b_upload_project',
                           primaryjoin='Project.id==Project_Upload.project_id',
                           cascade="all, delete-orphan")

    children = relationship("Project",
                            # cascade deletions
                            #cascade="all, delete-orphan",
                            backref=backref("parent", remote_side=id))

    worklog = relationship('WorkLog',
                           backref='b_project_worklog',
                           order_by=[desc('WorkLog.dt')],
                           primaryjoin='Project.id==WorkLog.project_id',
                           cascade="all, delete-orphan"
                           )

    category = relationship('Project_Category',
                            backref='b_project_category',
                            order_by=[asc('Project_Category.code')],
                            primaryjoin='Project.id==Project_Category.project_id',
                            cascade="all, delete-orphan"
                            )

    status = relationship('Project_Status',
                          backref='b_project_status',
                          order_by=[asc('Project_Status.nro')],
                          primaryjoin='Project.id==Project_Status.project_id',
                          cascade="all, delete-orphan"
                          )

    milestone = relationship('Project_Milestone',
                             backref='b_project_milestone',
                             order_by=[asc('Project_Milestone.code')],
                             primaryjoin='Project.id==Project_Milestone.project_id',
                             cascade="all, delete-orphan"
                             )


class Project_Usr(Base, MkMixin):
    id = Column(BigInteger, Sequence("gn_project_usr"), primary_key=True)
    usr_id = Column(BigInteger, ForeignKey("usr.id",
                                           onupdate="CASCADE",
                                           ondelete="CASCADE",
                                           name="fk_project_usr_usr"),
                    nullable=False)
    usr_code = column_property(select([literal_column('Usr.code')],
                                      from_obj=text('Usr')).where(text('Usr.id=Project_Usr.usr_id')))

    project_id = Column(BigInteger, ForeignKey("project.id",
                                               onupdate="CASCADE",
                                               ondelete="CASCADE",
                                               name="fk_project_usr_project"),
                        nullable=False)
    project_code = column_property(select([literal_column('Project.code')],
                                          from_obj=text('Project')).where(text('Project.id=Project_Usr.project_id')))

    usrrole_id = Column(BigInteger, ForeignKey("usrrole.id",
                                               onupdate="CASCADE",
                                               ondelete="NO ACTION",
                                               name="fk_project_usr_usrrole"))
    usrrole_code = column_property(select([literal_column('UsrRole.code')],
                                          from_obj=text('UsrRole')).where(text('UsrRole.id=Project_Usr.usrrole_id')))

    __table_args__ = (UniqueConstraint('usr_id', 'project_id', name='uq_project_usr_1'), MkMixin.__table_args__)


class Project_Upload(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_project_upload'), primary_key=True)

    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="CASCADE",
                                               onupdate="CASCADE",
                                               name="fk_project_upload_project"),
                        nullable=False)

    upload_id = Column(BigInteger, ForeignKey("upload.id",
                                              ondelete="CASCADE",
                                              onupdate="CASCADE",
                                              name="fk_project_upload_upload"),
                       nullable=False)

    defi = Column(String(200))

    uuid = column_property(select([literal_column('Upload.uuid')],
                                  from_obj=text('Upload')).where(text('Project_Upload.upload_id=Upload.id')))
    file_name = column_property(select([literal_column('Upload.file_name')],
                                       from_obj=text('Upload')).where(text('Project_Upload.upload_id=Upload.id')))


class Project_Milestone(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_project_milestone'), primary_key=True)
    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="CASCADE",
                                               onupdate="CASCADE",
                                               name="fk_project_milestone_project"),
                        nullable=False)
    code = Column(String(30), nullable=False)
    name = Column(String(200))
    dt_plan = Column(Date, nullable=False)

    is_active = Column(Boolean, default=True)
    is_released = Column(Boolean, default=False)

    active_count = column_property(select([func.count(literal_column('Issue.id'))], from_obj=text("Issue")).
                                   where(and_(text("Issue.milestone_id=Project_Milestone.id"),
                                              text("(select issue_closed from project_status where project_status.id=issue.status_id) = 0")
                                              ))
                                   )

    closed_count = column_property(select([func.count(literal_column('Issue.id'))], from_obj=text("Issue")).
                                   where(and_(text("Issue.milestone_id=Project_Milestone.id"),
                                              text("(select issue_closed from project_status where project_status.id=issue.status_id) = 1")
                                              ))
                                   )

    @property
    def total_count(self):
        return self.active_count + self.closed_count

    @property
    def percentage(self):
        if self.total_count > 0:
            return (self.closed_count / self.total_count) * 100
        else:
            return 0

    __table_args__ = (UniqueConstraint('project_id', 'code', name='uq_project_milesone_1'), MkMixin.__table_args__)


class Project_Status(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_project_status'), primary_key=True)
    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="CASCADE",
                                               onupdate="CASCADE",
                                               name="fk_project_status_project"),
                        nullable=False)
    code = Column(String(30), nullable=False)
    nro = Column(Integer, nullable=False, default=0)
    issue_closed = Column(Boolean, default=False, nullable=False)

    __table_args__ = (UniqueConstraint('project_id', 'code', name='uq_project_status_1'), MkMixin.__table_args__)


class Project_Category(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_project_category'), primary_key=True)
    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="CASCADE",
                                               onupdate="CASCADE",
                                               name="fk_project_category_project"),
                        nullable=False)
    code = Column(String(30), nullable=False)

    __table_args__ = (UniqueConstraint('project_id', 'code', name='uq_project_category_1'), MkMixin.__table_args__)


class Upload(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_upload'), primary_key=True)
    uuid = Column(String(40), unique=True)
    file_name = Column(String(200))
    ext = Column(String(20))
    cnt = deferred(Column(BLOB))
    cnt_th = deferred(Column(BLOB))
    notes = Column(TEXT)
    mimetype = Column(String(100))


class Issue(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_issue'), primary_key=True)

    parent_id = Column(BigInteger, ForeignKey("issue.id",
                                              ondelete="CASCADE",
                                              onupdate="CASCADE",
                                              name="fk_issue_parent"))

    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="CASCADE",
                                               onupdate="CASCADE",
                                               name="fk_issue_project"),
                        nullable=False)

    project_code = column_property(select([literal_column('project.code')],
                                          from_obj=text('Project')).where(text('Project.id=Issue.project_id')))

    usr_id_from = Column(BigInteger,  ForeignKey("usr.id",
                                                 ondelete="NO ACTION",
                                                 onupdate="CASCADE",
                                                 name="fk_issue_usr_from"),
                         nullable=False)

    usr_code_from = column_property(select([literal_column('usr.code')],
                                           from_obj=text('Usr')).where(text('Usr.id=Issue.usr_id_from')))

    usr_id_assigned = Column(BigInteger, ForeignKey("usr.id",
                                                    ondelete="NO ACTION",
                                                    onupdate="CASCADE",
                                                    name="fk_issue_usr_assigned"))

    usr_code_assigned = column_property(select([literal_column('usr.code')],
                                               from_obj=text('Usr')).where(text('Usr.id=Issue.usr_id_assigned')))

    category_id = Column(BigInteger, ForeignKey(Project_Category.id,
                                                ondelete="NO ACTION",
                                                onupdate="CASCADE",
                                                name="fk_issue_category"),
                         nullable=False)

    category = column_property(select([literal_column('Project_Category.code')],
                                      from_obj=text('Project_Category')).
                               where(text('Project_Category.id=Issue.category_id')))

    status_id = Column(BigInteger, ForeignKey(Project_Status.id,
                                              ondelete="NO ACTION",
                                              onupdate="CASCADE",
                                              name="fk_issue_status"),
                       nullable=False)

    status = column_property(select([literal_column('Project_Status.code')],
                                    from_obj=text('Project_Status')).
                             where(text('Project_Status.id=Issue.status_id')))

    status_nro = column_property(select([literal_column('Project_Status.nro')],
                                        from_obj=text('Project_Status')).
                                 where(text('Project_Status.id=Issue.status_id')))

    issue_closed = column_property(select([literal_column('Project_Status.issue_closed')],
                                          from_obj=text('Project_Status')).
                                   where(text('Project_Status.id=Issue.status_id')))

    priority_id = Column(BigInteger, ForeignKey("dfissuepriority.id",
                                                ondelete="NO ACTION",
                                                onupdate="CASCADE",
                                                name="fk_issue_dfissuepriority"),
                         nullable=False)

    priority = column_property(select([literal_column('DfIssuePriority.code')],
                                      from_obj=text('DfIssuePriority')).
                               where(text('DfIssuePriority.id=Issue.priority_id')))

    priority_nro = column_property(select([literal_column('DfIssuePriority.nro')],
                                          from_obj=text('DfIssuePriority')).
                                   where(text('DfIssuePriority.id=Issue.priority_id')))

    dt_open = Column(Date)
    dt_due = Column(Date)
    dt_plan = Column(Date)
    dt_plan_fn = Column(Date)
    estimated_hours = Column(Numeric(9, 2))

    reference = Column(String(30)) #Karşı danışman firmaya iş açılıyorsa onun referansı

    milestone_id = Column(BigInteger, ForeignKey("project_milestone.id",
                                                 ondelete="SET NULL",
                                                 onupdate="CASCADE",
                                                 name="fk_issue_milestone"))
    milestone = column_property(select([literal_column('Project_Milestone.code')],
                                       from_obj=text('Project_Milestone')).
                                where(text('Project_Milestone.id=Issue.milestone_id')))
    milestone_name = column_property(select([literal_column('Project_Milestone.name')],
                                            from_obj=text('Project_Milestone')).
                                where(text('Project_Milestone.id=Issue.milestone_id')))

    last_update = column_property(select([literal_column('Issue_Changeset.zlins_dttm')],
                                         from_obj=text('Issue_Changeset')).
                                  where(text('Issue_Changeset.issue_id=Issue.id')).
                                  order_by(desc('Issue_Changeset.zlins_dttm')).limit(1))

    last_updated_by_usr_id = column_property(select([literal_column('Issue_Changeset.usr_id')],
                                                    from_obj=text('Issue_Changeset')).
                                             where(text('Issue_Changeset.issue_id=Issue.id')).
                                             order_by(desc('Issue_Changeset.zlins_dttm')).limit(1))

    last_updated_by_usr_code = column_property(select([Usr.code], from_obj=Usr).
                                               where(Usr.id == select([literal_column('Issue_Changeset.usr_id')],
                                                                      from_obj=text('Issue_Changeset')).
                                                     where(text('Issue_Changeset.issue_id=Issue.id')).
                                                     order_by(desc('Issue_Changeset.zlins_dttm')).limit(1)))

    """
    spent_hours = column_property(select(
        [literal_column()]
    ))
    """

    @property
    def age(self):
        if type(self.dt_open) != str:
            _delta = datetime.date.today() - self.dt_open
            return _delta.days
        else:
            return 0

    @property
    def overdue(self):
        if self.dt_due and type(self.dt_due) != str:
            _delta = datetime.date.today() - self.dt_due
            return _delta.days
        else:
            return 0

    @property
    def overplan(self):
        if self.dt_plan and type(self.dt_plan) != str:
            _delta = datetime.date.today() - self.dt_plan
            return _delta.days
        else:
            return 0


    title = Column(String(200))
    description = Column(TEXT)

    is_private = Column(Boolean, nullable=False, default=False)

    done_ratio = Column(Integer, default=0)

    uploads = relationship('Issue_Upload',
                           backref='b_upload_issue',
                           primaryjoin='Issue.id==Issue_Upload.issue_id',
                           cascade="all, delete-orphan")

    watchers = relationship('Issue_Usr',
                            backref="b_usr_issue",
                            primaryjoin="Issue.id==Issue_Usr.issue_id",
                            cascade="all, delete-orphan")

    logs = relationship('Issue_Log',
                        backref="b_log_issue",
                        primaryjoin="Issue.id==Issue_Log.issue_id",
                        cascade="all, delete-orphan")

    comments = relationship('Issue_Comment',
                            backref="b_comment_issue",
                            primaryjoin="Issue.id==Issue_Comment.issue_id",
                            cascade="all, delete-orphan")

    changes = relationship('Issue_Changeset',
                           backref="b_changeset_issue",
                           primaryjoin="Issue.id==Issue_Changeset.issue_id",
                           cascade="all, delete-orphan",
                           order_by="Issue_Changeset.id")

    rels = relationship('Issue_Rel',
                        backref="b_rel_issue",
                        primaryjoin="Issue.id==Issue_Rel.issue_id_src",
                        cascade="all, delete-orphan",
                        order_by="Issue_Rel.id")

    #referenced as dst
    refs = relationship('Issue_Rel',
                        backref="b_ref_issue",
                        primaryjoin="Issue.id==Issue_Rel.issue_id_dst",
                        cascade="all, delete-orphan",
                        order_by="Issue_Rel.id")


class Issue_Upload(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_issue_upload'), primary_key=True)

    changeset = Column(BigInteger, ForeignKey("issue_changeset.id",
                                                 ondelete="SET NULL",
                                                 onupdate="CASCADE",
                                                 name="fk_issue_upload_changeset"))

    issue_id = Column(BigInteger, ForeignKey("issue.id",
                                             ondelete="CASCADE",
                                             onupdate="CASCADE",
                                             name="fk_issue_upload_issue"),
                      nullable=False)

    upload_id = Column(BigInteger, ForeignKey("upload.id",
                                              ondelete="CASCADE",
                                              onupdate="CASCADE",
                                              name="fk_issue_upload_upload"),
                       nullable=False)

    defi = Column(String(200))

    uuid = column_property(select([literal_column('Upload.uuid')],
                                  from_obj=text('Upload')).
                           where(text('Issue_Upload.upload_id=Upload.id')))
    file_name = column_property(select([literal_column('Upload.file_name')],
                                       from_obj=text('Upload')).
                                where(text('Issue_Upload.upload_id=Upload.id')))


class Issue_Changeset(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_issue_changeset'), primary_key=True)

    issue_id = Column(BigInteger, ForeignKey("issue.id",
                                             ondelete="CASCADE",
                                             onupdate="CASCADE",
                                             name="fk_issue_changeset_issue"),
                      nullable=False)

    usr_id = Column(BigInteger, ForeignKey("usr.id",
                                           ondelete="SET NULL",
                                           onupdate="CASCADE",
                                           name="fk_issue_changeset_usr"))
    usr_code = column_property(select([literal_column('Usr.code')],
                                      from_obj=text('Usr')).
                               where(text('Usr.id=Issue_Changeset.usr_id')))

    uploads = relationship('Issue_Upload',
                           backref='b_upload_changeset',
                           primaryjoin='Issue_Changeset.id==Issue_Upload.changeset')

    logs = relationship('Issue_Log',
                        backref="b_log_changeset",
                        primaryjoin="Issue_Changeset.id==Issue_Log.changeset")

    comments = relationship('Issue_Comment',
                            backref="b_comment_changeset",
                            primaryjoin="Issue_Changeset.id==Issue_Comment.changeset")


class Issue_Log(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_issue_log'), primary_key=True)

    changeset = Column(BigInteger, ForeignKey("issue_changeset.id",
                                              ondelete="SET NULL",
                                              onupdate="CASCADE",
                                              name="fk_issue_log_changeset"))

    issue_id = Column(BigInteger, ForeignKey("issue.id",
                                             ondelete="CASCADE",
                                             onupdate="CASCADE",
                                             name="fk_issue_log_issue"),
                      nullable=False)

    field_name = Column(String(50))
    old_val = Column(TEXT)
    new_val = Column(TEXT)

    caption = Column(String(50))

    old_val_text = Column(TEXT)
    new_val_text = Column(TEXT)


@events.event.listens_for(Issue_Log, 'before_insert')
@events.event.listens_for(Issue_Log, 'before_update')
def issue_log_biu(mapper, connection, target):
    target.old_val_text = None
    target.new_val_text = None

    if target.field_name == 'parent_id':
        target.caption  = _('Parent Issue')

    elif target.field_name == 'project_id':
        target.caption = _('Project')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from project where id = %d' %(int(target.old_val)))

        target.new_val_text = connection.scalar('select code from project where id = %d' %(int(target.new_val)))

    elif target.field_name == 'usr_id_from':
        target.caption = _('Reporter')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from usr where id = %d' %(int(target.old_val)))
        target.new_val_text = connection.scalar('select code from usr where id = %d' %(int(target.new_val)))

    elif target.field_name == 'usr_id_assigned':
        target.caption = _('Assignee')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from usr where id = %d' %(int(target.old_val)))
        target.new_val_text = connection.scalar('select code from usr where id = %d' %(int(target.new_val)))

    elif target.field_name == 'category_id':
        target.caption = _('Category')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from project_category where id = %d' %(int(target.old_val)))
        target.new_val_text = connection.scalar('select code from project_category where id = %d' %(int(target.new_val)))

    elif target.field_name == 'status_id':
        target.caption = _('Status')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from project_status where id = %d' %(int(target.old_val)))
        target.new_val_text = connection.scalar('select code from project_status where id = %d' %(int(target.new_val)))

    elif target.field_name == 'priority_id':
        target.caption = _('Priority')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from dfissuepriority where id = %d' %(int(target.old_val)))
        target.new_val_text = connection.scalar('select code from dfissuepriority where id = %d' %(int(target.new_val)))

    elif target.field_name == 'milestone_id':
        target.caption = _('Milestone')

        if target.old_val:
            target.old_val_text = connection.scalar('select code from project_milestone where id = %d' %(int(target.old_val)))
        target.new_val_text = connection.scalar('select code from project_milestone where id = %d' %(int(target.new_val)))

    elif target.field_name == 'dt_open':
        target.caption = _('Date Opened')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'dt_due':
        target.caption = _('Due Date')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'dt_plan':
        target.caption = _('Plan Start Date')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'dt_plan_fn':
        target.caption = _('Plan Finish Date')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'estimated_hours':
        target.caption = _('Estimated Hours')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'reference':
        target.caption = _('Reference Ticket')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'title':
        target.caption = _('Title')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'description':
        target.caption = _('Description')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'is_private':
        target.caption = _('Private')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val

    elif target.field_name == 'done_ratio':
        target.caption = _('% Done')

        target.old_val_text = target.old_val
        target.new_val_text = target.new_val


class Issue_Rel(Base, MkMixin):
    id = Column(BigInteger, Sequence("gn_issue_rel"), primary_key=True)

    issue_id_src = Column(BigInteger, ForeignKey("issue.id",
                                                 ondelete="CASCADE",
                                                 onupdate="CASCADE",
                                                 name="fk_issue_issue_rel_src"),
                          nullable=False)
    issue_src = relationship('Issue',
                             primaryjoin="Issue.id==Issue_Rel.issue_id_src")


    issue_id_dst = Column(BigInteger, ForeignKey("issue.id",
                                                 ondelete="CASCADE",
                                                 onupdate="CASCADE",
                                                 name="fk_issue_issue_rel_dst"),
                          nullable=False)
    issue_dst = relationship('Issue',
                             primaryjoin="Issue.id==Issue_Rel.issue_id_dst")

    #REL Types Are :
    #REL : Related To
    #DUP : Duplicates
    #PRE : Precedes
    #FLW : Follows
    #BLK : Blocks
    #STW : Starts With
    #ENW : Ends With

    rel_type = Column(String(10))
    @property
    def rel_type_def(self):
        if self.rel_type == 'REL':
            return _('Related To')
        elif self.rel_type == 'DUP':
            return _('Duplicates')
        elif self.rel_type == 'PRE':
            return _('Precedes')
        elif self.rel_type == 'FLW':
            return _('Follows')
        elif self.rel_type == 'BLK':
            return _('Blocks')
        elif self.rel_type == 'STW':
            return _('Starts With')
        elif self.rel_type == 'ENW':
            return _('Ends With')


class Issue_Usr(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_issue_usr'), primary_key=True)

    usr_id = Column(BigInteger, ForeignKey("usr.id", ondelete="CASCADE", onupdate="CASCADE", name="fk_issue_usr_usr"))
    usr_code = column_property(select([literal_column('Usr.code')],
                                      from_obj=text('Usr')).
                               where(text('Usr.id=Issue_Usr.usr_id')))

    issue_id = Column(BigInteger, ForeignKey("issue.id", ondelete="CASCADE", onupdate="CASCADE", name="fk_issue_usr_issue"))


class Issue_Comment(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_issue_comment'), primary_key=True)

    changeset = Column(BigInteger, ForeignKey("issue_changeset.id",
                                              ondelete="SET NULL",
                                              onupdate="CASCADE",
                                              name="fk_issue_comment_changeset"))

    issue_id = Column(BigInteger, ForeignKey("issue.id",
                                             ondelete="CASCADE",
                                             onupdate="CASCADE",
                                             name="fk_issue_comment_issue"),
                      nullable=False)

    usr_id = Column(BigInteger, ForeignKey("usr.id", ondelete="CASCADE", onupdate="CASCADE", name="fk_issue_comment_usr"))
    usr_code = column_property(select([literal_column('Usr.code')],
                                      from_obj=text('Usr')).where(text('Usr.id=Issue_Comment.usr_id')))

    comment = Column(TEXT)


class Wiki(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_wiki'), primary_key=True)
    title = Column(String(200))
    link = Column(String(200))

    parent_id = Column(BigInteger, ForeignKey("wiki.id",
                                              ondelete="CASCADE",
                                              onupdate="CASCADE",
                                              name="fk_wiki_parent"))

    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="SET NULL",
                                               onupdate="CASCADE",
                                               name="fk_wiki_project"))

    project_code = column_property(select([literal_column('Project.code')],
                                          from_obj=text('Project')).
                                   where(text('Project.id=Wiki.project_id')))
    client_code = column_property(select([literal_column('Client.code')],
                                         from_obj=text('Client')).
                                  where(text('Client.id=(select client_id from project where project.id=wiki.project_id)')))

    text = Column(TEXT)

    __table_args__ = (UniqueConstraint('project_id', 'link', name='uq_wiki_1'), MkMixin.__table_args__)


class WorkLog(Base, MkMixin):
    id = Column(BigInteger, Sequence('gn_worklog'), primary_key=True)

    issue_id = Column(BigInteger, ForeignKey("issue.id",
                                             ondelete="SET NULL",
                                             onupdate="CASCADE",
                                             name="fk_worklog_issue"))

    project_id = Column(BigInteger, ForeignKey("project.id",
                                               ondelete="SET NULL",
                                               onupdate="CASCADE",
                                               name="fk_worklog_project"))
    project_code = column_property(select([literal_column('Project.code')],
                                          from_obj=text('Project')).
                                   where(text('Project.id=Worklog.project_id')))
    client_code = column_property(select([literal_column('Client.code')],
                                         from_obj=text('Client')).
                                  where(text('Client.id=(select client_id from project where project.id=worklog.project_id)')))

    usr_id = Column(BigInteger, ForeignKey("usr.id",
                                           ondelete="CASCADE",
                                           onupdate="CASCADE",
                                           name="fk_worklog_usr"),
                    nullable=False)

    usr_code = column_property(select([literal_column('Usr.code')],
                                      from_obj=text('Usr')).where(text('Usr.id=Worklog.usr_id')))

    description = Column(Text)
    location = Column(String(200))

    dt = Column(Date, nullable=False)

    tm_st = Column(Time)
    tm_fn = Column(Time)

    bill_to_client = Column(Boolean, default=False)
    is_billed = Column(Boolean, default=False)

    @property
    def dttm_st(self):
        if self.dt and self.tm_st:
            return datetime.datetime.combine(self.dt, self.tm_st)
        else:
            return None

    @property
    def dttm_fn(self):
        if self.dt and self.tm_fn:
            return datetime.datetime.combine(self.dt, self.tm_fn)
        else:
            return None

    @property
    def duration(self):
        if self.dttm_st and self.dttm_fn:
            _delta = self.dttm_fn - self.dttm_st
            return _delta
        else:
            return None


def db_default_vals():

    dbsession = scoped_session(sessionmaker(bind=engine))  # http://docs.sqlalchemy.org/en/rel_0_8/orm/session.html?highlight=scoped_session#sqlalchemy.orm.scoping.scoped_session

    #Clients
    u = dbsession.query(Client)
    u.delete()
    dbsession.commit()

    for k in [[1, 'Makki'],
              [2, 'Makliftsan'],
              [3, 'Astaş'],
              [4, 'Aktifsped']]:
        rw = Client()
        rw.id = k[0]
        rw.code = k[1]
        dbsession.add(rw)
    dbsession.commit()

    #Users
    u = dbsession.query(Usr)
    u.delete()
    dbsession.commit()

    for k in [[1, 'admin', 'admin', 'info@makki.com.tr', True, 1],
              [2, 'guest', 'guest', 'guest@xyz.com', False, 1],
              [3, 'zuhtu', '123', 'xx@yy.com', False, 2]
    ]:
        rw = Usr()
        rw.id = k[0]
        rw.code = k[1]
        rw.upass = k[2]
        rw.email = k[3]
        rw.is_admin = k[4]
        rw.client_id = k[5]
        dbsession.add(rw)
    dbsession.commit()

    #Projects
    u = dbsession.query(Project)
    u.delete()
    dbsession.commit()

    for k in [[1, 'PM', None, 1, False]]:
        rw = Project()
        rw.id = k[0]
        rw.code = k[1]
        rw.parent_id = k[2]
        rw.client_id = k[3]
        rw.is_public = k[4]
        dbsession.add(rw)
    dbsession.commit()


    #User Roles
    u = dbsession.query(UsrRole)
    u.delete()
    dbsession.commit()

    for k in [['1', 'Project Admin'],
              ['2', 'Developer'],
              ['3', 'Key User'],
              ['4', 'User'],
              ['5', 'Client Rep.']]:
        rw = UsrRole()
        rw.id = k[0]
        rw.code = k[1]
        dbsession.add(rw)
    dbsession.commit()

    #Priorities
    u = dbsession.query(DfIssuePriority)
    u.delete()
    dbsession.commit()
    for k in [['1', 'Very Low'],
              ['2', 'Low'],
              ['3', 'Medium'],
              ['4', 'High'],
              ['5', 'Show Breaker']]:
        rw = DfIssuePriority()
        rw.id = k[0]
        rw.code = k[1]
        rw.nro = k[0]
        dbsession.add(rw)
    dbsession.commit()

    #Categories
    u = dbsession.query(DfIssueCategory)
    u.delete()
    for k in [['1', 'Bug'],
              ['2', 'Feature Request'],
              ['3', 'Enhancement']
    ]:
        rw = DfIssueCategory()
        rw.id = k[0]
        rw.code = k[1]
        dbsession.add(rw)
    dbsession.commit()
    dbsession.commit()

    #Status
    u = dbsession.query(DfIssueStatus)
    u.delete()
    for k in [['1', 'New', 1, 0],
              ['2', 'On Progress', 2, 0],
              ['3', 'Waiting For Deployment', 3, 0],
              ['4', 'In Customer Test', 4, 0],
              ['5', 'Closed', 5, 1],
              ['6', 'Rejected', 6, 0],
    ]:
        rw = DfIssueStatus()
        rw.id = k[0]
        rw.code = k[1]
        rw.nro = k[2]
        rw.issue_closed = k[3]
        dbsession.add(rw)
    dbsession.commit()
    dbsession.commit()

    #Default site specific configurations
    u = dbsession.query(Config)
    u.delete()
    dbsession.commit()
    xid = 0
    for k in [['home_page', 'Home Page', 1],
              ['site_title', 'Site Title', 'Makki Issue Management System'],
              ['default_language', 'Default Language', '1']]:
        xid += 1
        cconf = Config()
        cconf.code = k[0]
        cconf.defi = k[1]
        cconf.cval = k[2]
        cconf.id = xid
        dbsession.add(cconf)
    dbsession.commit()

    #Default Languages
    u = dbsession.query(DfLang)
    u.delete()
    dbsession.commit()

    for k in [[1, 'en', 'English'], [2, 'tr', 'Türkçe'], [3, 'de', 'Deutsch']]:
        clang = DfLang()
        clang.id = k[0]
        clang.code = k[1]
        clang.defi = k[2]
        dbsession.add(clang)
    dbsession.commit()

    #Default Projects Pages

if __name__ == "__main__":
    import app
    init_sa(app.baseApp.config)
    Base.metadata.create_all()
    #db_default_vals()




