% include('_header.tpl')

% include('_project_tab_header.tpl')

% setdefault('project', arec.code)

% include('_list_issue.tpl', alst=issues, show_project_column=False)

% include('_project_tab_footer.tpl')

% include('_footer.tpl')

% include('_tablesorter_js.tpl')
