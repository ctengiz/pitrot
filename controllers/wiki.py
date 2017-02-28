from bottle import Bottle, request
from sqlalchemy import and_

from utils import render, try_commit
from i18n import _
from dbcon import Wiki, Project

subApp = Bottle()


@subApp.route('/wikiopr', method=['POST'])
def wikiopr(db):
    id = int(request.POST.id) if request.POST.id else None
    project_id = int(request.POST.project_id) if request.POST.project_id else None
    parent_id = int(request.POST.parent_id) if request.POST.parent_id else None

    wiki = db.query(Wiki).filter(and_(Wiki.id == id)).first()

    if not wiki:
        wiki = Wiki()
        db.add(wiki)

    wiki.link = request.POST.link
    wiki.project_id = project_id
    wiki.parent_id = parent_id
    wiki.title = request.POST.title
    wiki.text = request.POST.text

    return try_commit(db, True, wiki, 'id')


@subApp.route('/wiki/<link>', method=['GET'])
@subApp.route('/wiki/<project_code>/<link>', method=['GET'])
def wiki_page(db, project_code, link):
    if project_code:
        project = db.query(Project).filter(Project.code == project_code).first()
    else:
        project = Project()

    wiki = db.query(Wiki).filter(and_(Wiki.link == link, Wiki.project_id == project.id)).first()
    wikis = db.query(Wiki).filter(Wiki.project_id == project.id).all()

    if not wiki:
        wiki = Wiki()

        wiki.link = link

        if link == 'home' and project.id:
            wiki.title = _('%s HomePage' %(project.code))
            wiki.text = _('This is projects homepage. You can edit it.')
        else:
            wiki.title = link

        wiki.project_id = project.id
        db.add(wiki)
        db.commit()

    if project:
        return render('project_tab_wiki',
                      arec=project,
                      wiki=wiki,
                      wikis=wikis,
                      page=link)


