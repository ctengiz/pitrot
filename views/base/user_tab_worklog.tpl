% include('_header.tpl')

% include('_user_tab_header.tpl')

% include('_list_worklog.tpl', lst=arec.worklog, show_user_column=False)

% include('_user_tab_footer.tpl')

% include('_footer.tpl')

% include('_tablesorter_js.tpl')
