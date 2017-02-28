% include('_header.tpl')

% include('_project_tab_header.tpl')


<div class="row" style="margin-top: 5px;">
    %if arec.notes:
    <div class="col-sm-12">
        <div class="well">
            {{arec.notes}}
        </div>
    </div>
    %end


    <div class="col-sm-4">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Issue Summary')}}</h3>
            </div>
            <ul class="list-group">
                %for rw in issue_summary:
                <li class="list-group-item">
                    <a href="/project/{{arec.code}}/issues?status_id={{rw.status_id}}">{{rw.status_nro}} - {{rw.status}}</a>
                    <span class="badge alert-danger">{{rw.cnt}}</span>
                </li>
                %end
            </ul>
        </div>
    </div>

    <div class="col-sm-4">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Project Members')}}
                    <span class="pull-right"><a href="#"><small>{{_('Add')}}</small></a></span>
                </h3>
            </div>
            <table class="table">
                %for rw in arec.users:
                    <tr>
                        <td>
                            <a href="/user/{{rw.usr_id}}">{{rw.usr_code}}</a>
                        </td>
                        <td>
                            {{rw.usrrole_code}}
                        </td>
                        <td>
                            <!-- todo: member operations -->
                            <a href="/notready"><span class="glyphicon glyphicon-pencil"></span></a>
                            <a href="/notready" style="margin-left: 5px; color: rgb(209, 91, 71);"><span class="glyphicon glyphicon-trash"></span></a>
                        </td>
                    </tr>
                %end
            </table>
        </div>
    </div>

    <div class="col-sm-4">
        <div class="panel panel-warning">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('User / Issue Assignment')}}</h3>
            </div>
            <div class="panel-body">

                <div class="panel-group" role="tablist" aria-multiselectable="true" id="accordion_user">
                    %tcode = ""
                    %for rw in usr_summary:
                        %if tcode != rw.usr_code_assigned:
                            %if tcode != '':
                                </ul></div></div>
                            %end
                            %tcode = rw.usr_code_assigned
                            <div class="panel panel-info">
                                <div class="panel-heading" role="tab" id="user_ph{{rw.usr_id_assigned}}">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse"
                                        href="#usr{{rw.usr_id_assigned}}"
                                       aria-expanded="true" aria-controls="usr{{rw.usr_id_assigned}}"
                                    >
                                    </a>
                                    <h4 class="panel-title">
                                        %if rw.usr_code_assigned:
                                            <a href="/user/{{rw.usr_code_assigned}}">
                                            {{rw.usr_code_assigned}}
                                            </a>
                                        %else:
                                            {{_('Unassigned')}}
                                        %end
                                    </h4>
                                </div>
                                <div id="usr{{rw.usr_id_assigned}}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="{{rw.usr_id_assigned}}">
                                    <ul class="list-group">
                        %end
                        <li class="list-group-item">
                            <span class="badge">{{rw.cnt}}</span>
                            %if rw.usr_code_assigned:
                                <a href="/project/{{arec.code}}/issues?status_id={{rw.status_id}}&usr_id_assigned={{rw.usr_id_assigned}}">
                                    {{rw.status_nro}} - {{rw.status}}
                                </a>
                            %else:
                                <a href="/project/{{arec.code}}/issues?status_id={{rw.status_id}}&ck_unassigned=on">
                                    {{rw.status_nro}} - {{rw.status}}
                                </a>
                            %end
                        </li>
                    %end
                    %if tcode != '':
                        </ul></div></div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-sm-4">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Sub Projects')}}</h3>
            </div>
            <table class="table">
                %for rw in arec.children:
                <tr>
                    <td>
                        <a href="/project/{{rw.code}}">{{rw.code}}</a>
                    </td>
                    <td>
                        <a href="/client/{{rw.client_code}}">{{rw.client_code}}</a>
                    </td>
                </tr>
                %end
            </table>
        </div>
    </div>


    <div class="col-sm-4">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Milestones')}}</h3>
            </div>
            <div class="panel-body">
                #TODO
            </div>
        </div>
    </div>

    <div class="col-sm-4">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Projects Wiki / Documentation')}}</h3>
            </div>
            <div class="panel-body">
                #TODO
            </div>
        </div>
    </div>

</div>

% include('_project_tab_footer.tpl')

% include('_footer.tpl')

