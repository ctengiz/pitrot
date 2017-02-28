%setdefault('show_project_column', True)
%setdefault('show_client_column', True)
%setdefault('show_user_column', True)
%setdefault('col_count', 0)

<div class="row">
    <div class="col-sm-12">
        <table class="table table-striped table-condensed" id="atable">
            <thead>
                <tr>
                    <th data-sorter="shortDate" data-date-format="ddmmyyyy">{{_('Date')}}</th>
                    %col_count += 1
                    <th data-sorter="shortDate" data-date-format="hh:mm">{{_('Start / Stop Time')}}</th>
                    %col_count += 1
                    <th>{{_('Duration')}}</th>
                    %col_count += 1
                    <th>{{_('Description')}}</th>
                    %col_count += 1
                    <th>{{_('Location')}}</th>
                    %col_count += 1
                    %if show_user_column:
                    <th>{{_('User')}}</th>
                    %col_count += 1
                    %end

                    <th>{{_('Bill To Client')}}</th>
                    %col_count += 1

                    %if show_client_column:
                    <th class="filter-select">{{_('Client')}}</th>
                    %col_count += 1
                    %end

                    %if show_project_column:
                    <th class="filter-select">{{_('Project')}}</th>
                    %col_count += 1
                    %end
                    <th>{{_('Issue')}}</th>
                    %col_count += 1
                    <th>{{_('ID')}}</th>
                    %col_count += 1
                    <th>&nbsp;</th>
                    %col_count += 1
                </tr>
            </thead>
            %include('_tablesorter_footer.tpl')
            <tbody>
            % for rw in lst:
            <tr>
                <td>{{date_to_str(rw.dt)}}</td>
                <td>{{date_to_str(rw.tm_st)}} - {{date_to_str(rw.tm_fn)}}</td>
                <td>{{rw.duration}}</td>
                <td>{{rw.description}}</td>
                <td>{{rw.location}}</td>
                %if show_user_column:
                <td><a href="/user/{{rw.usr_id}}">{{rw.usr_code}}</a></td>
                %end
                <td style="text-align: center; width: 70px;">
                    {{! '<span class="glyphicon glyphicon-ok"></span>' if rw.bill_to_client else '&nbsp;'}}
                </td>
                %if show_client_column:
                <td>
                    <a href="/client/{{rw.client_code}}">
                        {{rw.client_code}}
                    </a>
                </td>
                %end
                %if show_project_column:
                <td>
                    <a href="/project/{{rw.project_code}}">
                        {{rw.project_code}}
                    </a>
                </td>
                %end
                <td><a href="/issue/{{rw.issue_id}}">{{rw.issue_id}}</a></td>
                <td><a href="/worklog/{{rw.id}}">{{rw.id}}</a></td>
                %if session['is_admin']:
                <td style="width: 60px;">
                    <%
                    if defined('project'):
                        setdefault('pparam', '?project=%s' %project)
                    else:
                        setdefault('pparam', '')
                    end
                    %>

                    <div class="btn-group btn-group-xs">
                        <a href="/worklog/edit/{{rw.id}}{{pparam}}" class="btn btn-primary" title="{{_('Edit')}}">
                            <span class="glyphicon glyphicon-edit"></span>
                        </a>
                        <!-- todo: confirmation -->
                        <a href="/worklog/del/{{rw.id}}{{pparam}}" class="btn btn-danger" title="{{_('Delete')}}">
                            <span class="glyphicon glyphicon-trash"></span>
                        </a>
                    </div>

                </td>
                %end
            </tr>
            % end
            </tbody>
        </table>
    </div>
</div>


