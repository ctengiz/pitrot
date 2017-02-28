% include('_header.tpl')

%if config['general.welcome_text']:
    <div class="row">
        <div class="col-md-12">
            <div class="well">
                {{!config['general.welcome_text']}}
            </div>
        </div>
    </div>
%end

<div class="row">
    <div class="col-sm-2">
        <div class="panel panel-success">
            <div class="panel-heading">
                <h3 class="panel-title">
                    {{_('My Projects')}}
                </h3>
            </div>
            <table class="table table-bordered">
                <tbody>
                %for rw in _prj:
                <tr>
                    <td>
                        <a href="/project/{{rw.code}}">
                            {{rw.code}}
                        </a>
                    </td>
                    <td style="width: 50%;">
                        <a href="/issue/add?project={{rw.code}}" class="btn btn-warning btn-xs" role="btn">
                            <span class="glyphicon glyphicon-bullhorn"></span>
                        </a>
                        <a href="/worklog/add?project={{rw.code}}" class="btn btn-info btn-xs" role="btn">
                            <span class="glyphicon glyphicon-time"></span>
                        </a>
                    </td>
                </tr>
                %end
                </tbody>
            </table>
        </div>
    </div>

    <div class="col-sm-10">
        <div class="row">
            <div class="col-sm-6">
                <div class="panel panel-warning">
                    <div class="panel-heading">
                        <h3 class="panel-title">{{_('Issues Opened By Me')}}</h3>
                    </div>
                    <table class="table">
                        <tbody>
                        %for rw in _issue:
                        <tr>
                            <td>
                                {{date_to_str(rw.dt_open)}}
                            </td>
                            <td>
                                <a href="/issue/{{rw.id}}?project={{rw.project_code}}">{{rw.title}}</a>
                            </td>
                            <td>
                                <a href="/project/{{rw.project_code}}">{{rw.project_code}}</a>
                            </td>
                        </tr>
                        %end
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-sm-6">
                <div class="panel panel-danger">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            {{_('Issues Assigned To Me')}}
                        </h3>
                    </div>
                    <table class="table">
                        <tbody>
                        %for rw in _issue_to:
                        <tr>
                            <td>
                                {{date_to_str(rw.dt_open)}}
                            </td>
                            <td>
                                <a href="/issue/{{rw.id}}?project={{rw.project_code}}">{{rw.title}}</a>
                            </td>
                            <td>
                                <a href="/project/{{rw.project_code}}">{{rw.project_code}}</a>
                            </td>
                        </tr>
                        %end
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <div class="row">
            <div class="col-sm-12">
                <div class="panel panel-info">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            {{_('Latest Updates')}}
                        </h3>
                    </div>
                    % include("_list_activity", alst = _updates)
                </div>
            </div>
        </div>


    </div>
</div>


% include('_footer.tpl')