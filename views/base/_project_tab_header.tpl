
<div class="row">
    <div class="col-xs-9">
        <h2 style="margin-top: 0px;">
            {{arec.code}}
            <small>(<a href="/client/{{arec.client_code}}">{{arec.client_code}}</a>)</small>
        </h2>
    </div>
    <div class="col-xs-3">
        <div class="pull-right">

            <!-- todo: yetki kontrolü -->
            <a type="button" href="/issue/add?project={{arec.code}}" class="btn btn-warning btn-xs">
                <span class="glyphicon glyphicon-bullhorn"></span>&nbsp;{{_('New Issue')}}
            </a>

            <!-- todo : yetki kontrolü -->
            <a type="button" href="/worklog/add?project={{arec.code}}" class="btn btn-info btn-xs">
                <span class="glyphicon glyphicon-time"></span>&nbsp;{{_('Worklog')}}
            </a>

            %if session['is_admin']:
            <a type="button" href="/admin/project/edit/{{arec.id}}" class="btn btn-primary btn-xs">
                <span class="glyphicon glyphicon-edit"></span>&nbsp;{{_('Edit Project')}}
            </a>
            %end
        </div>
    </div>
</div>

<div class="row">
    <div class="col-sm-12">
        <ul class="nav nav-tabs">
            <li class="{{'active' if page=='overview' else ''}}">
                <a href="{{'#' if page=='overview' else '/project/%s/overview' %(arec.code)}}">{{_('Overview')}}</a>
            </li>
            <li class="{{'active' if page=='issues' else ''}}">
                <a href="{{'#' if page=='issues' else '/project/%s/issues' %(arec.code) }}">{{_('Issues')}}</a>
            </li>
            <li class="{{'active' if page=='activity' else ''}}">
                <a href="{{'#' if page=='activity' else '/project/%s/activity' %(arec.code) }}">{{_('Activity')}}</a>
            </li>
            <li class="{{'active' if page=='files' else ''}}">
                <a href="{{'#' if page=='files' else '/project/%s/files' %(arec.code) }}">{{_('Files')}}</a>
            </li>
            <li class="{{'active' if page=='worklog' else ''}}">
                <a href="{{'#' if page=='worklog' else '/project/%s/worklog' %(arec.code) }}">{{_('Worklog')}}</a>
            </li>
            <li class="{{'active' if page=='calendar' else ''}}">
                <a href="{{'#' if page=='calendar' else '/project/%s/calendar' %(arec.code) }}">{{_('Calendar')}}</a>
            </li>
            <li class="{{'active' if page=='wiki' else ''}}">
                <a href="{{'#' if page=='wiki' else '/wiki/%s/home' %(arec.code) }}">{{_('Wiki')}}</a>
            </li>
            <!-- todo: news
            <li class="{{'active' if page=='news' else ''}}">
                <a href="{{'#' if page=='news' else '/project/%s/wiki' %(arec.code) }}">{{_('News')}}</a>
            </li>
            -->
            <li class="{{'active' if page=='roadmap' else ''}}">
                <a href="{{'#' if page=='roadmap' else '/project/%s/roadmap' %(arec.code) }}">{{_('Roadmap')}}</a>
            </li>
            <!-- todo : pert chart
            <li class="{{'active' if page=='pert' else ''}}">
                <a href="{{'#' if page=='pert' else '/project/%s/pert' %(arec.code) }}">{{_('Pert Chart')}}</a>
            </li>
            -->
            <!-- todo: gannt chart
            <li class="{{'active' if page=='gantt' else ''}}">
                <a href="{{'#' if page=='gantt' else '/project/%s/gantt' %(arec.code) }}">{{_('Gantt Chart')}}</a>
            </li>
            -->

            <!-- todo: yetki kontrolü -->
            <li class="{{'active' if page=='settings' else ''}}">
                <a href="{{'#' if page=='settings' else '/project/%s/settings' %(arec.code) }}">{{_('Settings')}}</a>
            </li>
        </ul>
    </div>
</div>

