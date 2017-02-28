% include('_header.tpl')

<!-- Begin Issue Header -->
<div class="row">
    <div class="col-xs-12">
        <div class="bs-callout bs-callout-danger" style="margin-top: 0;">
            <div class="row">
                <div class="col-xs-10">
                    <h2>
                        #{{arec.id}}
                        {{arec.title}}
                        <small>
                            [<a href="/project/{{arec.project_code}}">{{arec.project_code}}</a>]
                        </small>
                    </h2>
                </div>
                <div class="col-xs-2">
                    <div class="pull-right btn-group btn-group-xs">
                        <!-- todo: yetkilendirme -->
                        <a href="#" class="btn btn-primary btn-edit-issue" type="button">
                            <span class="glyphicon glyphicon-edit"></span>
                            {{_('Edit')}}
                        </a>
                        <a href="#" class="btn btn-info btn-worklog" type="button">
                            <span class="glyphicon glyphicon-time"></span>
                            {{_('Worklog')}}
                        </a>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <h5 style="margin-top: 2px; margin-bottom: 2px;">
                        <strong>
                            {{_('Opened By')}} :
                        </strong>
                        <a href="/user/arec.usr_id">{{arec.usr_code_from}}</a>

                        <strong>
                            {{_('Date Opened')}} :
                        </strong>
                        {{date_to_str(arec.dt_open)}}

                        <strong>
                            {{_('Assignee')}} :
                        </strong>
                         <a href="/user/{{arec.usr_id_assigned}}">{{arec.usr_code_assigned}}</a>
                    </h5>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /End Issue Header -->

<!-- Begin Issue description -->
<div class="row">
    <div class="col-xs-12">
        <div class="bs-callout bs-callout-info">
            {{! render_comment(arec.description)}}
        </div>
    </div>
</div>
<!-- End Issue Description -->

<div class="panel panel-warning">
    <div class="panel-body">
        <div class="row">
            <div class="col-xs-2"><strong>{{_('Category')}}</strong></div>
            <div class="col-xs-2">
                <a href="/project/{{arec.project_code}}/issues?category_id={{arec.category_id}}">
                    {{arec.category}}
                </a>
            </div>

            <div class="col-xs-2"><strong>{{_('Status')}}</strong></div>
            <div class="col-xs-2">
                <a href="/project/{{arec.project_code}}/issues?status_id={{arec.status_id}}">
                    {{arec.status}}
                </a>
            </div>

            <div class="col-xs-2"><strong>{{_('Priority')}}</strong></div>
            <div class="col-xs-2">
                <a href="/project/{{arec.project_code}}/issues?priority_id={{arec.priority_id}}">
                    {{arec.priority}}
                </a>
            </div>
        </div>

        <div class="row">
            <div class="col-xs-2"><strong>{{_('Date Opened')}}</strong></div>
            <div class="col-xs-2">{{date_to_str(arec.dt_open)}}</div>

            <div class="col-xs-2"><strong>{{_('Due Date')}}</strong></div>
            <div class="col-xs-2">{{date_to_str(arec.dt_due)}} </div>

            <div class="col-xs-2"><strong>{{_('Reference')}}</strong></div>
            <div class="col-xs-2">{{arec.reference}}</div>
        </div>
        <div class="row">
            <div class="col-xs-2"><strong>{{_('Plan Date')}}</strong></div>
            <div class="col-xs-2">{{date_to_str(arec.dt_plan)}}</div>

            <div class="col-xs-2"><strong>{{_('MileStone')}}</strong></div>
            <div class="col-xs-2">
                <a href="/project/{{arec.project_code}}/issues?milestone_id={{arec.milestone_id}}">
                    {{arec.milestone}}
                </a>
            </div>

            <div class="col-xs-2"><strong>{{_('Estimated vs Spent Hours')}}</strong></div>
            <div class="col-xs-1">{{arec.estimated_hours}}</div>
            <!-- <div class="col-xs-2"><strong>{{_('Spent Time')}}</strong></div> -->
            <div class="col-xs-1">todo !!</div>

            <div class="col-xs-2"><strong>{{_('% Done')}}</strong></div>
            <div class="col-xs-2">
                <div class="progress" style="margin-bottom: 0px;">
                    <div class="progress-bar" role="progressbar" aria-valuenow="{{arec.done_ratio}}" aria-valuemin="0" aria-valuemax="100" style="width: {{arec.done_ratio}}%;">
                        <span class="sr-only">{{arec.done_ratio}}% {{_('Complete')}}</span>
                    </div>
                </div>
            </div>
        </div>

        <hr />
        <div class="row">
            <div class="col-xs-1">
                <strong>{{_('Watchers')}}</strong>
            </div>
            <div class="col-xs-10" id="div-watcher-list">
                %for rw in arec.watchers:
                <div class="btn-group btn-group-xs" id="watcher-{{rw.usr_id}}" >
                    <a href="/user/{{rw.usr_id}}" type="button" class="btn btn-info">{{rw.usr_code}}</a>
                    <button type="button" class="btn btn-warning btn-del-watcher" data-value="{{rw.usr_id}}" data-opr="del">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </div>
                %end
            </div>
            <div class="col-xs-1">
                <div class="pull-right">
                    <a href="#"
                       id="add-watcher"
                       data-title="{{_('Add Watcher')}}">
                        <span class="glyphicon glyphicon-user"></span>&nbsp;{{_('Add')}}
                    </a>
                </div>
            </div>
        </div>

        <hr />
        <div class="row">
            <div class="col-xs-1">
                <strong>{{_('Related Files')}}</strong>
            </div>
            <div class="col-xs-11">
                <ul class="list-group">
                    %for rw in arec.uploads:
                        <li class="list-group-item">
                            <div class="row">
                                <div class="col-xs-1"></div>
                                <div class="col-xs-10">
                                    <a href="/uploads/{{rw.uuid}}">
                                        {{rw.file_name}}
                                    </a>
                                    &nbsp;
                                    {{rw.defi}}
                                </div>
                                <div class="col-xs-1">
                                    <div class="pull-right">
                                        <!-- todo: file operations -->
                                        <a href="/notready"><span class="glyphicon glyphicon-pencil"></span></a>
                                        <a href="/notready" style="margin-left: 5px;" class="text-red"><span class="glyphicon glyphicon-trash"></span></a>
                                    </div>
                                </div>
                            </div>
                        </li>
                    %end
                </ul>
            </div>
        </div>

        <hr />
        <div class="row">
            <div class="col-xs-1">
                <strong>{{_('Subtasks')}}</strong>
            </div>
        </div>

        <hr />
        <div class="row">
            <div class="col-xs-1">
                <strong>{{_('Related Issues')}}</strong>
            </div>

            <div class="col-xs-10">
                <table id="tbl-rel" class="table table-condensed table-bordered">
                    %for rw in arec.rels:
                    <tr data-rel-id="{{rw.issue_id_dst}}" data-row-id="{{rw.id}}">
                        <td>{{rw.rel_type_def}}</td>
                        <td>
                            <a href="/issue/{{rw.issue_id_dst}}">
                                {{rw.issue_id_dst}} - {{rw.issue_dst.title}}
                            </a>
                        </td>
                        <td>
                            <a href="#" class="btn btn-danger btn-xs rel-remove"
                               data-src-id="{{rw.issue_id_src}}"
                               data-dst-id="{{rw.issue_id_dst}}" >
                                <i class="glyphicon glyphicon-trash"></i>
                            </a>
                        </td>
                    </tr>
                    %end
                    %for rw in arec.refs:
                    <tr data-rel-id="{{rw.issue_id_src}}" data-row-id="{{rw.id}}">
                        <td>{{rw.rel_type_def}}</td>
                        <td>
                            <a href="/issue/{{rw.issue_id_src}}">
                                {{rw.issue_id_src}} - {{rw.issue_src.title}}
                            </a>
                        </td>
                        <td>
                            <a href="#" class="btn btn-danger btn-xs rel-remove"
                               data-src-id="{{rw.issue_id_src}}"
                               data-dst-id="{{rw.issue_id_dst}}" >
                                <i class="glyphicon glyphicon-trash"></i>
                            </a>
                        </td>
                    </tr>
                    %end

                </table>

                <div class="form-group form-group-sm" id="div-related-issues-select" style="display: none">
                    <label class="col-xs-1 control-label">{{_('Relation Type')}}</label>
                    <div class="col-xs-2">
                        <select class="form-control col-xs-4" name="_rel_typ" id="_rel-typ">
                            <option value="REL">{{_('Related To')}}</option>
                            <option value="DUP">{{_('Duplicates')}}</option>
                            <option value="PRE">{{_('Precedes')}}</option>
                            <option value="FLW">{{_('Follows')}}</option>
                            <option value="BLK">{{_('Blocks')}}</option>
                            <option value="STW">{{_('Starts With')}}</option>
                            <option value="ENW">{{_('Ends With')}}</option>
                        </select>
                    </div>

                    <label class="col-xs-1 control-label">{{_('Related Issue')}}</label>
                    <div class="col-xs-6">
                        <input class="form-control" id="_rel-issue-id" name="_rel_issue_id">
                    </div>

                    <div class="col-xs-2">
                        <div class="btn-group btn-group-xs">
                            <a href="#" id="rel-confirm" class="btn btn-success">
                                <i class="glyphicon glyphicon-check"></i>
                            </a>
                            <a href="#" id="rel-cancel" class="btn btn-warning">
                                <i class="glyphicon glyphicon-remove"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-1">
                <a href="#" id="add-related-issue" class="btn btn-xs btn-primary pull-right" data-title="{{_('Add')}}">
                    <span class="glyphicon glyphicon-plus"></span>&nbsp;{{_('Add')}}
                </a>

            </div>


        </div>
    </div>
</div>

%if arec.changes:
<div class="row" id="div-updates">
    <div class="col-xs-12">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">
                <span class="glyphicon glyphicon-comment"></span>
                {{_('Recent Updates')}}
            </h3>
            <a href="#" class="pull-right" style="margin-top: -14px; margin-left: 5px;">Hide Updates</a>
            <span class="label label-info pull-right" style="margin-top: -14px;">
                {{len(arec.changes)}}
            </span>
        </div>
        <div class="panel-body" id="panel-updates">
            <ul class="list-group">
            %for _cm in arec.changes:
            <li class="list-group-item">
                <div class="row">
                    <div class="col-xs-1">
                        <!-- todo: burada profil fotosu olmalı -->
                        <img src="http://placehold.it/80" class="img-circle img-responsive" alt="" />
                    </div>
                    <div class="col-xs-11">
                        <h4 class="text-success" style="border-bottom: 1px solid #3C763D;">
                        {{_('Updated by')}} <a href="/user/{{_cm.usr_id}}">{{_cm.usr_code}}</a> on
                            <small>
                                {{date_to_str(_cm.zlins_dttm)}}
                            </small>
                        </h4>

                        <!-- Comment -->
                        %if _cm.comments:
                            <div class="panel panel-success" id="comment-{{_cm.comments[0].id}}">
                                <div class="panel-heading">
                                    {{_('Comment Added')}}
                                    <div class="btn-group btn-group-xs pull-right">
                                    <a href="#" class="btn-edt-comment"  data-id="{{_cm.comments[0].id}}">
                                        <span class="glyphicon glyphicon-pencil"></span></a>
                                    <a href="#" class="text-red btn-del-comment" data-id="{{_cm.comments[0].id}}" style="margin-left: 5px;">
                                        <span class="glyphicon glyphicon-trash"></span></a>
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div id="comment-text-{{_cm.comments[0].id}}">
                                        {{!render_comment(_cm.comments[0].comment)}}
                                    </div>
                                </div>
                                <div class="panel-footer"
                                     id="comment-footer-{{_cm.comments[0].id}}"
                                     style="display: none;">
                                    <a href="#" class="btn-post-comment btn btn-success"  data-id="{{_cm.comments[0].id}}">
                                        <span class="glyphicon glyphicon-ok"></span> {{_('Post Comment')}}</a>
                                </div>
                            </div>
                        %end
                        <!-- End Of Comment -->

                        %if _cm.uploads:
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    {{_('Files Added:')}}
                                </div>
                                <ul class="list-group">
                                    %for _fl in _cm.uploads:
                                    <li class="list-group-item">{{_fl.file_name}}</li>
                                    %end
                                </ul>
                            </div>
                        %end
                        %if _cm.logs:
                        <div class="panel panel-warning">
                            <div class="panel-heading">
                                {{_('Issue Data Updates')}}
                            </div>
                            <table class="table table-condensed table-bordered">
                                <tr>
                                    <th>Caption</th><th>Old Val</th><th>New Val</th>
                                </tr>
                                %for _ll in _cm.logs:
                                <tr>
                                    <th>{{_ll.caption}}</th><td>{{!_ll.old_val_text}}</td><td>{{!_ll.new_val_text}}</td>
                                </tr>
                                %end
                            </table>
                        </div>
                        %end
                    </div>
                </div>
            </li>
            %end
            </ul>
        </div>
    </div>
    </div>
</div>
%end

<form class="form-horizontal" role="form" method="post" id="frm-post" enctype="multipart/form-data">
    <div class="panel panel-success">
        <div class="panel-heading" id="div-header-edit-issue" style="display: none;">
            <h3 class="panel-title">{{_('Edit Issue')}}</h3>
        </div>

        <div class="panel-body" id="div-body-edit-issue" style="display: none;">
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Title')}}</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="title" value="{{arec.title}}" placeholder="{{_('Title')}}" required>
                </div>
                <div class="col-sm-2">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="is_private" value="1" {{ "checked" if arec.is_private else "" }}> {{_('Private')}}
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="col-xs-2 control-label">{{_('Category')}}</label>
                <div class="col-xs-2">
                    <select name="category_id" class="form-control" required>
                        <option value="">{{_('Please select')}}</option>
                        %for k in cats:
                        <option value="{{k.id}}" {{ "selected" if arec.category_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>

                <label class="col-xs-2 control-label">{{_('Status')}}</label>
                <div class="col-xs-2">
                    <select name="status_id" class="form-control" required>
                        <option value="">{{_('Please select')}}</option>
                        %for k in stas:
                        <option value="{{k.id}}" {{ "selected" if arec.status_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>

                <label class="col-xs-2 control-label">{{_('Priority')}}</label>
                <div class="col-xs-2">
                    <select name="priority_id" class="form-control" required>
                        <option value="">{{_('Please select')}}</option>
                        %for k in prit:
                        <option value="{{k.id}}" {{ "selected" if arec.priority_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>

            </div>

            <div class="form-group">
                <!-- todo : burada yetki kontrolü olmalı -->
                <label class="col-xs-2 control-label">{{_('Project')}}</label>
                <div class="col-xs-2">
                    <input class="form-control" id="project-id" name="project_id" value="{{arec.project_id}}" required {{ "" if session['is_admin'] else "readonly" }}>
                </div>

                <label class="col-xs-2 control-label">{{_('Reporter')}}</label>
                <div class="col-xs-2">
                    <!-- todo: admin ise başkasının adına da iş açabilmeli -->

                    %if not session['is_admin']:
                        <input type="text" class="form-control" name="usr_code_from" value="{{arec.usr_code_from}}" required readonly>
                        <input class="form-control" name="usr_id_from" value="{{arec.usr_id_from}}" type="hidden">
                    %else:
                        <input class="form-control" name="usr_id_from" value="{{arec.usr_id_from}}" id="usr-id-from">
                    %end

                </div>

                <label class="col-xs-2 control-label">{{_('Assignee')}}</label>
                <div class="col-xs-2">
                    <!--
                    <input type="text" class="form-control" name="usr_code_assigned" value="{{arec.usr_code_assigned}}">
                    -->
                    <input type="hidden" class="form-control" name="usr_id_assigned" value="{{arec.usr_id_assigned}}" id="usr-id-assigned">
                </div>
            </div>

            <div class="form-group">
                <label class="col-xs-2 control-label">{{_('Date Opened')}}</label>
                <div class="col-xs-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_open" value="{{date_to_str(arec.dt_open)}}" placeholder="{{_('Date opened')}}" required>
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

                <label class="col-xs-2 control-label">{{_('Due Date')}}</label>
                <div class="col-xs-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_due" value="{{date_to_str(arec.dt_due)}}" placeholder="{{_('Due date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

                <label class="col-sm-2 control-label">{{_('Reference')}}</label>
                <div class="col-sm-2">
                    <input type="text" class="form-control" name="reference" value="{{arec.reference}}" placeholder="{{_('Reference ticket')}}">
                </div>

            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Plan Date')}}</label>
                <div class="col-sm-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_plan" value="{{date_to_str(arec.dt_plan)}}" placeholder="{{_('Planned date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

                <label class="col-sm-2 control-label">{{_('Milestone')}}</label>
                <div class="col-sm-2">
                    <select name="milestone_id" class="form-control">
                        <option value="">{{_('Please select')}}</option>
                        %for k in mile:
                        <option value="{{k.id}}" {{ "selected" if arec.milestone_id == k.id else " " }}>{{k.code}} {{k.name}} </option>
                        %end
                    </select>
                </div>


                <label class="col-sm-2 control-label">{{_('Estimated Hours')}} / {{_('% Done')}}</label>
                <div class="col-sm-1">
                    <input type="text" class="form-control" name="estimated_hours" value="{{arec.estimated_hours}}" placeholder="{{_('Estimated Hours')}}">
                </div>

                <!-- <label class="col-sm-1 control-label">{{_('% Done')}}</label> -->
                <div class="col-sm-1">
                    <select name="done_ratio" class="form-control">
                        %for _p in range(0, 110, 10):
                        <option value="{{_p}}" {{'selected' if arec.done_ratio == _p else ''}}>%{{_p}}</option>
                        %end
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="col-xs-2 control-label">
                    {{_('Description')}}
                    <a href="#" id="btn-show-description"> {{_('Edit')}}</a>
                    <a href="#" id="btn-hide-description" style="display: none;"> {{_('Hide')}}</a>
                </label>
                <div class="col-xs-10">
                    <div id="div-edit-description" style="display: none;">
                        <div id="summernote-description">{{! arec.description}}</div>
                        <div style="display: none;">
                            <textarea class="form-control" rows="8" name="description">{{arec.description}}</textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="panel-heading">
            <h3 class="panel-title">
                {{_('Comments')}}
                <div class="btn-group btn-group-xs pull-right" style="margin-top: -2px;">
                    <!-- todo: yetkilendirme -->
                    <a href="#" class="btn btn-primary btn-edit-issue" type="button">
                        <span class="glyphicon glyphicon-edit"></span>
                        {{_('Edit Issue Details')}}
                    </a>
                    <a href="#" class="btn btn-info btn-worklog" type="button">
                        <span class="glyphicon glyphicon-time"></span>
                        {{_('Worklog')}}
                    </a>
                </div>
            </h3>

        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-xs-12">
                    <div id="summernote-comment" style="height: 450px;"></div>
                    <textarea class="form-control" rows="8" name="comment" style="display: none;"></textarea>
                </div>
            </div>

            <div class="row" style="margin-top: 5px;">
                <div class="col-xs-12">
                    % include('_upload_image')
                </div>
            </div>

        </div>

        <!-- todo: yetkilendirme -->
        <div class="panel-heading" style="display: none;" id="div-header-worklog">
            {{_('Worklog')}}
        </div>
        <div class="panel-body" style="display: none;" id="div-body-worklog">
            <div class="row">
                <div class="col-xs-12">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Date')}}</label>
                        <div class="col-sm-2">
                            <div class="date input-group">
                                <input type="text" class="form-control" name="wl_dt" value="{{current_date()}}" placeholder="{{_('Date')}}">
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-calendar"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Start / Stop Time')}}</label>
                        <div class="col-sm-2">
                            <div class="time input-group">
                                <input type="text" class="form-control" name="wl_tm_st" placeholder="{{_('Start time')}}">
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-time"></span>
                                </span>
                            </div>
                        </div>
                        <!--<label class="col-sm-2 control-label">{{_('Finish')}}</label>-->
                        <div class="col-sm-2">
                            <div class="time input-group">
                                <input type="text" class="form-control" name="wl_tm_fn" placeholder="{{_('Stop time')}}">
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-time"></span>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Description')}}</label>
                        <div class="col-sm-10">
                            <textarea name="wl_description" class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Location')}}</label>
                        <div class="col-sm-10">
                            <input type="text" name="wl_location" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Bill to Client')}}</label>
                        <div class="col-sm-2">
                            <input type="checkbox" name="wl_bill_to_client" value="1">
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="panel-footer">
            <button type="submit" class="btn btn-primary">
                <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Save')}}
            </button>
            <a type="button" class="btn btn-warning" href="/project/{{arec.project_code}}/issues">
                <span class="glyphicon glyphicon-remove"></span> {{_('Cancel')}}
            </a>
        </div>
    </div>
</form>


%include('_footer.tpl')

<script type="text/template" id="watcher-template">
    <div class="btn-group btn-group-xs" id="watcher-{usr_id}" >
        <a href="/user/{usr_id}" type="button" class="btn btn-info">{usr_code}</a>
        <button type="button" class="btn btn-warning btn-del-watcher" data-value="{usr_id}" data-opr="del">
            <span class="glyphicon glyphicon-remove"></span>
        </button>
    </div>
</script>

<script type="text/javascript">
var get_data = function(typ, project_id) {
    var adata;

    $.ajaxSetup({async: false});
    $.post("/ajax/" + typ,
            {"project_id": project_id},
            "json").done(function(data){
                adata = eval(data);
            });
    $.ajaxSetup({async: true});

    return adata;
};


var format_item = function (item) {
    return item.id + '-' + item.code;
};

var do_select2 = function(ainput, adata, multiple, containerClass, formatter) {

    $(ainput).select2({
        placeholder: "{{_('Please select')}}",
        multiple: multiple,
        allowClear: true,
        data:{
            results: adata,
            text:'code'},
        formatSelection: formatter,
        formatResult: formatter,
        containerCssClass: containerClass
    });

};


$(document).ready(function(){

    $("#frm-post").validate({});

    $('#summernote-description').summernote({height: 150});

    $('#summernote-comment').summernote({height: 150});

    $('#frm-post').submit( function() {
        $("textarea[name='description']").val($('#summernote-description').code());
        $("textarea[name='comment']").val($('#summernote-comment').code());
        return true;
    });

    var project_id = "{{arec.project_id}}";
    var issue_id = "{{arec.id}}";
    var project_data;

    $.ajaxSetup({async: false});
    $.post("/ajax/project", "json").done(function(data){
        project_data = eval(data);
    });
    $.ajaxSetup({async: true});
    var usr_data = get_data('usr', project_id);
    var issue_data = get_data('issue', project_id);

    $('#project-id').select2({
        placeholder: "{{_('Please select')}}",
        allowClear: true,
        data:{
            results: project_data,
            text:'code'},
    });

    do_select2('#usr-id-assigned', usr_data);
    do_select2('#usr-id-from', usr_data);
    do_select2('#_rel-issue-id', issue_data, false, 'select2-sm', format_item);


    $('#add-watcher').editable({
        url: '/issue_watcher/{{arec.id}}',
        ajaxOptions: {
            type: 'post',
            dataType: 'json'
        },
        send: 'always',
        params: {opr: "add"},
        type: "select2",
        display: false,
        select2: {
            placeholder: "{{_('Please select')}}",
            allowClear: true,
            data:{
                results: usr_data,
                text:'code'},
        },
        success: function(response, newValue) {
            if (response.success == 1) {
                var _watcher_text =templateString(
                        $("#watcher-template").text(),
                        {
                            usr_id: response.usr_id,
                            usr_code: response.usr_code
                        }
                );
                $("#div-watcher-list").append(_watcher_text);
            } else if (response.success == 2) {
                //do nothing ! user already exists !
            } else{
                alert(response.message);
            }
        }

    });

    $("#div-watcher-list").on("click", ".btn-del-watcher", function(event){
        var pdata = $(this).data();

        $.ajax({
        type: "POST",
        url: '/issue_watcher/{{arec.id}}',
        data: pdata,
        success: function(data, textStatus, jqXHR) {
            if (data.success == 1) {
                $('#watcher-' + pdata.value).remove();
            } else {
                alert(data.message);
            }
        },
        dataType: 'json'
        });

        return false;
    });

    //Delete comment
    $("#div-updates").on("click", ".btn-del-comment", function(event){
        var id = $(this).data('id');
        $.ajax({
            type: "POST",
            url: '/issue_comment/' + id,
            data: {opr: 'del'},
            success: function(data, textStatus, jqXHR) {
                if (data.success == 1) {
                    $('#comment-' + id).remove();
                } else {
                    alert(data.message);
                }
            },
            dataType: 'json'
        });

        return false;
    });

    //Edit comment
    $("#div-updates").on("click", ".btn-edt-comment", function(event){
        var id = $(this).data('id');
        $('#comment-text-' + id).summernote();
        $('#comment-footer-' + id).show();
        return false;
    });

    //Post comment;
    $("#div-updates").on("click", ".btn-post-comment", function(event) {
        var id = $(this).data('id');
        var comment = $("#comment-text-" + id).code();

        $('#comment-text-' + id).destroy();
        $('#comment-footer-' + id).hide();

        $.ajax({
            type: "POST",
            url: '/issue_comment/' + id,
            data: {opr: 'edt', comment: comment},
            success: function(data, textStatus, jqXHR) {
                if (data.success == 1) {
                    return false;
                } else {
                    alert(data.message);
                }
            },
            dataType: 'json'
        });
        return false;
    });

    $(".btn-edit-issue").click(function(){
        $("#div-header-edit-issue").show();
        $("#div-body-edit-issue").show();
        $('html, body').animate({
            scrollTop: $("#div-header-edit-issue").offset().top
        }, 1000);
        return false;
    });

    $(".btn-worklog").click(function(){
        $("#div-header-worklog").show();
        $("#div-body-worklog").show();
        $('html, body').animate({
            scrollTop: $("#div-header-worklog").offset().top
        }, 1000);
        return false;
    });

    $("#btn-show-description").click(function(){
        $("#div-edit-description").show();
        $("#btn-hide-description").show();
        $("#btn-show-description").hide();
        return false;
    });

    $("#btn-hide-description").click(function(){
        $("#div-edit-description").hide();
        $("#btn-hide-description").hide();
        $("#btn-show-description").show();
        return false;
    });


    /* RELATED ISSUES */
    var rel_ids = [];

    //push previos ids
    $.each($("#tbl-rel tbody").children(), function( ndx, tr ) {
        var _tid = String($(tr).data('rel-id'));
        rel_ids.push(_tid);
    });

    $("#add-related-issue").click(function(){
        $('#div-related-issues-select').show();
        return false;
    });

    $("#rel-cancel").click(function(){
        $('#div-related-issues-select').hide();
        return false;
    });

    $("#rel-confirm").click(function(){
        var _id = $('#_rel-issue-id').select2("data");
        var _rt = $('#_rel-typ').val();
        var _rt_text = $('#_rel-typ :selected').text();

        //todo: better error display
        if ($.inArray(_id.id, rel_ids) >= 0) {
            alert('Already added !');
            return false;
        }

        $.ajax({
            type: "POST",
            url: '/issue_rel/0',
            data: {
                opr: 'add',
                issue_id_src: issue_id,
                issue_id_dst: _id.id,
                rel_type: _rt
            },
            success: function(data, textStatus, jqXHR) {
                if (data.success == 1) {
                    rel_ids.push(_id.id);

                    var _tr = '<tr data-rel-id="' + _id.id + '" data-row-id="' + data.id + '">'
                            + '<td>' + _rt_text + '</td>'
                            + '<td><a href="/issue/' + _id.id + '">' + _id.id + ' - ' + _id.code + '</a></td>'
                            + '<td><a href="#" class="btn btn-xs btn-danger rel-remove" data-rel="' + _id.id + '"><i class="glyphicon glyphicon-trash"></i></a></td>'
                            + '</tr>';
                    $("#tbl-rel").append(_tr);

                    return false;
                } else {
                    alert(data.message);
                }
            },
            dataType: 'json'
        });
        return false;

    });

    $("#tbl-rel").on('click', '.rel-remove', function(){
        var _id = String($(this).data('rel'));
        var _row_id = $(this).parent('td').parent('tr').data("row-id");
        var $this = $(this);

        $.ajax({
            type: "POST",
            url: '/issue_rel/' + _row_id,
            data: {opr: 'del'},
            success: function(data, textStatus, jqXHR) {
                if (data.success == 1) {
                    var _pos = $.inArray(_id, rel_ids);
                    if ( ~_pos ) rel_ids.splice(_pos, 1);

                    $this.parent('td').parent('tr').remove();
                    return false;
                } else {
                    alert(data.message);
                }
            },
            dataType: 'json'
        });
        return false;
    });
})


</script>