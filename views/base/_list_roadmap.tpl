%setdefault('show_project_column', True)
%setdefault('show_client_column', True)
%setdefault('show_user_column', True)

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title" style="font-size: 22px;">Roadmap</h3>
            </div>

            <ul class="list-group ">
            %for ml in arec.milestone:
                <li class="list-group-item" id="{{ml.id}}">
                    <div class="row">
                        <div class="col-md-6">
                            <h2>{{ml.code}} <small>{{ml.name}}</small></h2>
                            %if ml.is_active:
                            <label class="label label-success">{{_('Active')}}</label>
                            %else:
                            <label class="label label-default">{{_('Closed')}}</label>
                            %end

                            %if ml.is_released:
                            <label class="label label-warning">{{_('Released')}}</label>
                            %else:
                            <label class="label label-primary">{{_('In Development')}}</label>
                            %end
                        </div>
                        <div class="col-md-6">
                            <div class="progress" style="height: 22px;">
                                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0" aria-valuemax="100" style="width: {{ml.percentage}}%; line-height: 22px;">
                                    {{'{:.0f}'.format(ml.percentage)}}%
                                </div>
                            </div>
                            <a class="text-danger" href="/project/{{arec.code}}/issues?status=active&milestone_id={{ml.id}}">{{ml.active_count}} open</a>
                            <a class="text-success" href="/project/{{arec.code}}/issues?status=closed&milestone_id={{ml.id}}">{{ml.closed_count}} closed</a>
                            %if ml.dt_plan:
                                {{_('Due Date')}}: {{date_to_str(ml.dt_plan)}}
                            %else:
                                {{_('No due date')}}
                            %end
                        </div>
                    </div>
                </li>
            %end
            </ul>
        </div>

    </div>


</div>


