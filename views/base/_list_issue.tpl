%setdefault('show_project_column', True)
%setdefault('show_assigned_column', True)
%setdefault('show_opened_column', True)
%setdefault('show_watched_column', True)
%setdefault('tabtype', '')
%setdefault('ausr', 0)
%setdefault('col_count', 0)

<div class="row" style="margin-bottom: 5px; margin-top: 5px;">
    <div class="col-sm-12">
        <div class="well well-sm" style="margin-bottom: 0px;">
            <form name="ffilter" method="get" class="form-inline">
                <div class="form-group">
                    %if not show_project_column:
                    <a type="button" href="/issue/add?project={{arec.code}}" class="btn btn-warning btn-sm">
                        <span class="glyphicon glyphicon-bullhorn"></span>&nbsp;{{_('New Issue')}}
                    </a>
                    %else:
                    <a type="button" href="/issue/add" class="btn btn-warning btn-sm">
                        <span class="glyphicon glyphicon-bullhorn"></span>&nbsp;{{_('New Issue')}}
                    </a>
                    %end
                </div>
                <div class="form-group">
                    %setdefault('astat', (request.GET.status if 'status' in request.GET else 'active'))
                    <select name="status" class="form-control input-xs">
                        <option value="active" {{('selected' if astat=='active' else '')}} >{{_('Active')}}</option>
                        <option value="closed" {{('selected' if astat=='closed' else '')}}>{{_('Closed')}}</option>
                        <option value="all" {{('selected' if astat=='all' else '')}}>{{_('All')}}</option>
                    </select>
                </div>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_unassigned" {{('checked' if 'ck_unassigned' in request.GET else '')}}> {{_('Unassigned')}}
                    </label>
                </div>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_unplanned" {{('checked' if 'ck_unplanned' in request.GET else '')}}> {{_('Unplanned')}}</li>
                    </label>
                </div>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_noduedate" {{('checked' if 'ck_noduedate' in request.GET else '')}}> {{_('No Due Date')}}</li>
                    </label>
                </div>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_overplan" {{('checked' if 'ck_overplan' in request.GET else '')}}> {{_('Overplan')}}</li>
                    </label>
                </div>
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_overdue" {{('checked' if 'ck_overdue' in request.GET else '')}}> {{_('Overdue')}}</li>
                    </label>
                </div>

                %if show_assigned_column and tabtype != 'watched':
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_assignedtome" {{('checked' if 'ck_assignedtome' in request.GET else '')}}> {{_('Assigned To User')}}</li>
                    </label>
                </div>
                %end

                %if show_opened_column and tabtype !=' watched':
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_openedbyme" {{('checked' if 'ck_openedbyme' in request.GET else '')}}> {{_('Opened By User')}}</li>
                    </label>
                </div>
                %end

                %if show_watched_column:
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_watchedbyme" {{('checked' if 'ck_watchedbyme' in request.GET else '')}}> {{_('Watched By User')}}</li>
                    </label>
                </div>
                %end

                %if ausr:
                <input type="hidden" name="ausr" value="{{ausr}}">
                %end

                <div class="form-group">
                    <button type="submit" class="btn btn-success btn-sm">
                        <span class="glyphicon glyphicon-filter"></span> Filter
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>


<div class="row">
    <div class="col-sm-12">
        <table class="tablesorter" id="atable" data-sortlist="[[0,1]]">
            <thead>
                <tr>
                    <th>{{_('ID')}}</th>
                    %col_count += 1
                    %if show_project_column:
                    <th class="filter-select">{{_('Project')}}</th>
                    %col_count += 1
                    %end
                    <th>{{_('Definition')}}</th>
                    %col_count += 1
                    <th class="filter-select">{{_('Priority')}}</th>
                    %col_count += 1
                    <th class="filter-select">{{_('Status')}}</th>
                    %col_count += 1
                    <th class="filter-select">{{_('Category')}}</th>
                    %col_count += 1
                    %if show_opened_column:
                    <th>{{_('Reporter')}}</th>
                    %col_count += 1
                    %end
                    %if show_assigned_column:
                    <th>{{_('Assignee')}}</th>
                    %col_count += 1
                    %end
                    <th data-sorter="shortDate" data-date-format="ddmmyyyy">{{_('Opened')}}</th>
                    %col_count += 1
                    <th class="filter-select">{{_('Milestone')}}</th>
                    %col_count += 1
                    <th data-sorter="shortDate" data-date-format="ddmmyyyy">{{_('Plan')}}</th>
                    %col_count += 1
                    <th data-sorter="shortDate" data-date-format="ddmmyyyy">{{_('Due')}}</th>
                    %col_count += 1
                    <th style="width: 70px;">{{_('Age O.Pln O.Due')}}</th>
                    %col_count += 1
                    <th>{{_('Last Update')}}</th>
                    %col_count += 1
                </tr>
            </thead>
            %include('_tablesorter_footer')
            <tbody>
            % for rw in alst:
            <tr class="{{'text-muted' if rw.issue_closed else ''}}"
                style="{{'text-decoration: line-through;' if rw.issue_closed else ''}}"
                id="{{rw.id}}"
                data-usr_id_assigned="{{rw.usr_id_assigned}}"
                data-project_id="{{rw.project_id}}">
                <td>
                    <a href="/issue/{{rw.id}}">{{rw.id}}</a>

                </td>
                %if show_project_column:
                <td data-field="project_id">
                    <a href="/project/{{rw.project_code}}">
                        {{rw.project_code}}
                    </a>
                </td>
                %end
                <td>
                    <a href="/issue/{{rw.id}}">{{rw.title}}</a>
                </td>
                <td data-field="priority_id">{{rw.priority_nro}}-{{rw.priority}}</td>
                <td data-field="status_id">{{rw.status_nro}}-{{rw.status}}</td>
                <td data-field="category_id">{{rw.category}}</td>
                %if show_opened_column:
                <td><a href="/user/{{rw.usr_id_from}}">{{rw.usr_code_from}}</a></td>
                %end
                %if show_assigned_column:
                <td data-field="usr_id_assigned"><a href="/user/{{rw.usr_id_assigned}}">{{rw.usr_code_assigned}}</a></td>
                %end
                <td>{{date_to_str(rw.dt_open)}}</td>
                <td data-field="milestone_id">
                    <a href="/project/{{rw.project_code}}/roadmap#{{rw.milestone_id}}">
                        {{rw.milestone}} {{rw.milestone_name}}
                    </a>
                </td>
                <td data-field="dt_plan">{{date_to_str(rw.dt_plan)}}</td>
                <td data-field="dt_due">{{date_to_str(rw.dt_due)}}</td>
                <td>{{rw.age}} / {{rw.overplan}} / {{rw.overdue}}</td>
                <td>
                    {{date_to_str(rw.last_update)}} <br>
                    <a href="/user/{{rw.last_updated_by_usr_id}}">{{rw.last_updated_by_usr_code}}</a>
                </td>
            </tr>
            % end
            </tbody>
        </table>
    </div>
</div>


<ul id="contextMenu" class="dropdown-menu" role="menu" style="display:none" >
    <%
    if defined('project'):
        setdefault('pparam', '?project=%s' %project)
    else:
        setdefault('pparam', '')
    end
    %>
    <li><a href="#" tabindex="-1" data-act="usr_id_assigned">{{_('Assign To...')}}</a></li>
    <li class="dropdown-submenu">
        <a tabindex="-1" href="#">{{_('Set Priority')}}</a>
        <ul class="dropdown-menu">
            %for k in prit:
            <li><a href="#" tabindex="-1" data-val="{{k.id}}" data-act="priority_id">{{k.nro}}-{{k.code}}</a></li>
            %end
        </ul>
    </li>
    <li class="dropdown-submenu">
        <a tabindex="-1" href="#">{{_('Set Status')}}</a>
        <ul class="dropdown-menu">
            %for k in stas:
            <li><a href="#" tabindex="-1" data-val="{{k.id}}" data-act="status_id"  >{{k.nro}}-{{k.code}}</a></li>
            %end
        </ul>
    </li>
    <li class="dropdown-submenu">
        <a tabindex="-1" href="#">{{_('Set Category')}}</a>
        <ul class="dropdown-menu">
            %for k in cats:
            <li><a href="#" tabindex="-1" data-val="{{k.id}}" data-act="category_id">{{k.code}}</a></li>
            %end
        </ul>
    </li>
    <li><a href="#" tabindex="-1" data-act="dt_due">{{_('Due Date')}}</a></li>
    <li><a tabindex="-1" href="#" data-act="dt_plan">{{_('Plan Date')}}</a></li>
    <li class="dropdown-submenu">
        <a tabindex="-1" href="#">{{_('Milestone')}}</a>
        <ul class="dropdown-menu">
            %for k in mile:
            <li><a href="#" tabindex="-1" data-val="{{k.id}}" data-act="milestone_id">{{k.code}} {{k.name}}</a></li>
            %end
        </ul>
    </li>

    <li class="divider"></li>
    <li><a tabindex="-1" href="#">{{_('Ping Assignee')}}</a></li>
    <!-- todo: more proper grant check -->
    <li class="divider"></li>
    <li>
        <a tabindex="-1" href="#" data-act="edit" data-pparam="{{pparam}}">
            <span class="glyphicon glyphicon-edit"></span> {{_('Edit')}}
        </a>
    </li>
    <!-- todo: more proper grant check -->
    %if session['is_admin']:
    <li>
        <!-- todo: confirmation -->
        <a tabindex="-1" href="#" data-act="del" data-pparam="{{pparam}}">
            <span class="glyphicon glyphicon-trash"></span> {{_('Delete')}}
        </a>
    </li>
    %end

</ul>


<!-- Modal -->
<div class="modal fade" id="modal-dt_due" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">{{_('Set Due Date')}}</h4>
            </div>
            <div class="modal-body">
                <div class="date input-group">
                    <input type="text" class="form-control" name="dt_due" value="" placeholder="" id="popup-dt_due">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{_('Close')}}</button>
                <button type="button" class="btn btn-primary" data-act="dt_due">{{_('Apply')}}</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
        
<!-- Modal -->
<div class="modal fade" id="modal-dt_plan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">{{_('Set Plan Date')}}</h4>
            </div>
            <div class="modal-body">
                <div class="date input-group">
                    <input type="text" class="form-control" name="dt_plan" value="" placeholder="" id="popup-dt_plan">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{_('Close')}}</button>
                <button type="button" class="btn btn-primary" data-act="dt_plan">{{_('Apply')}}</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- Modal -->
<div class="modal fade" id="modal-usr_id_assigned" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">{{_('Assign User')}}</h4>
            </div>
            <div class="modal-body">
                <select class="form-control" id="popup-usr_id_assigned"></select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{_('Close')}}</button>
                <button type="button" class="btn btn-primary" data-act="usr_id_assigned">{{_('Apply')}}</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->