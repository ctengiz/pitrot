% include('_header.tpl')

% include('_user_tab_header.tpl')

<%
include('_list_issue', alst=issues, show_project_column=True,
    show_assigned_column=(tabtype != 'assigned'),
    show_opened_column=(tabtype != 'opened'),
    show_watched_column=False,
    tabtype=tabtype,
    ausr=arec.id
)
%>

% include('_user_tab_footer.tpl')

% include('_footer.tpl')

% include('_tablesorter_js.tpl')
