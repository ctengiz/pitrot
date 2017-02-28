% include('_header.tpl')

% include('_user_tab_header.tpl')


<div class="row" style="margin-top: 5px;">
    <div class="col-sm-4">
        <div class="panel panel-info">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Issue Summary')}}</h3>
            </div>
            <ul class="list-group">
                %for rw in issue_summary:
                <li class="list-group-item">
                    <a href="/user/{{arec.code}}/issues?status_code={{rw.code}}">{{rw.nro}} - {{rw.code}}</a>
                    <span class="badge alert-danger">{{rw.cnt}}</span>
                </li>
                %end
            </ul>
        </div>
    </div>

    <div class="col-sm-4">
        <div class="panel panel-warning">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Projects')}}</h3>
            </div>
            <div class="panel-body">

                <div class="panel-group" role="tablist" aria-multiselectable="true" id="accordion">
                    %setdefault('tcode', '')
                    %for rw in prj_summary:
                        %if tcode != rw.project_code:
                            %if tcode != '':
                                </ul></div></div>
                            %end
                            %tcode = rw.project_code
                            <div class="panel panel-info">
                                <div class="panel-heading" role="tab" id="project_ph{{rw.project_id}}">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse"
                                        href="#prj{{rw.project_id}}"
                                       aria-expanded="true" aria-controls="prj{{rw.project_id}}"
                                    >
                                    </a>
                                    <h4 class="panel-title">
                                        <a href="/project/{{rw.project_code}}">
                                        {{rw.project_code}}
                                        </a>
                                    </h4>
                                </div>
                                <div id="prj{{rw.project_id}}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="{{rw.project_id}}">
                                    <ul class="list-group">
                        %end
                        <li class="list-group-item">
                            <span class="badge">{{rw.cnt}}</span>
                            <a href="/project/{{rw.project_code}}/issues?status_id={{rw.status_id}}&usr_id_assigned={{arec.id}}">
                                {{rw.status_nro}} - {{rw.status}}
                            </a>
                        </li>
                    %end
                    %if tcode != '':
                        </ul></div></div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-4">
        <div class="panel panel-warning">
            <div class="panel-heading">
                <h3 class="panel-title">{{_('Clients')}}</h3>
            </div>
            <div class="panel-body">
                <div class="panel-group" role="tablist" aria-multiselectable="true" id="accordion_client">
                    %tcode = ""
                    %for rw in client_summary:
                        %if tcode != rw.code:
                            %if tcode != '':
                                </ul></div></div>
                            %end
                            %tcode = rw.code
                            <div class="panel panel-info">
                                <div class="panel-heading" role="tab" id="client_ph{{rw.id}}">
                                    <a class="accordion-toggle collapsed" data-toggle="collapse"
                                       href="#p{{rw.id}}"
                                       aria-expanded="true" aria-controls="{{rw.id}}"
                                    >
                                    </a>
                                    <h4 class="panel-title">
                                        <a href="/client/{{rw.code}}">
                                        {{rw.code}}
                                        </a>
                                    </h4>
                                </div>
                                <div id="p{{rw.id}}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="{{rw.id}}">
                                    <ul class="list-group">
                        %end
                        <li class="list-group-item">
                            <span class="badge">{{rw.cnt}}</span>
                            <a href="/client/{{rw.code}}/issues?status_code={{rw.status}}&usr_id_assigned={{arec.id}}">
                                {{rw.status_nro}} - {{rw.status}}
                            </a>
                        </li>
                    %end
                    %if tcode != '':
                        </ul></div></div>
                </div>
            </div>
        </div>
    </div>

</div>

% include('_user_tab_footer.tpl')

% include('_footer.tpl')

