
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
            <a type="button" href="/issue/add" class="btn btn-warning btn-xs">
                <span class="glyphicon glyphicon-bullhorn"></span>&nbsp;{{_('New Issue')}}
            </a>

            <!-- todo : yetki kontrolü -->
            <a type="button" href="/worklog/add" class="btn btn-info btn-xs">
                <span class="glyphicon glyphicon-time"></span>&nbsp;{{_('Worklog')}}
            </a>

            %if session['is_admin']:
            <a type="button" href="/admin/user/edit/{{arec.id}}" class="btn btn-primary btn-xs">
                <span class="glyphicon glyphicon-edit"></span>&nbsp;{{_('Edit User')}}
            </a>
            %end
        </div>
    </div>
</div>

<div class="row">
    <div class="col-sm-12">
        <ul class="nav nav-tabs">
            <li class="{{'active' if page=='overview' else ''}}">
                <a href="{{'#' if page=='overview' else '/user/%s/overview' %(arec.code)}}">{{_('Overview')}}</a>
            </li>
            <li class="{{'active' if page=='issues' else ''}}">
                <a href="{{'#' if page=='issues' else '/user/%s/issues' %(arec.code) }}">{{_('Issues Assigned')}}</a>
            </li>
            <li class="{{'active' if page=='issues_opened' else ''}}">
                <a href="{{'#' if page=='issues_opened' else '/user/%s/issues_opened' %(arec.code) }}">{{_('Issues Opened')}}</a>
            </li>
            <li class="{{'active' if page=='issues_watched' else ''}}">
                <a href="{{'#' if page=='issues_watched' else '/user/%s/issues_watched' %(arec.code) }}">{{_('Issues Watched')}}</a>
            </li>
            <li class="{{'active' if page=='activity' else ''}}">
                <a href="{{'#' if page=='activity' else '/user/%s/activity' %(arec.code) }}">{{_('Activity')}}</a>
            </li>
            <!--
            <li class="{{'active' if page=='files' else ''}}">
                <a href="{{'#' if page=='files' else '/user/%s/files' %(arec.code) }}">{{_('Files')}}</a>
            </li>
            -->
            <li class="{{'active' if page=='worklog' else ''}}">
                <a href="{{'#' if page=='worklog' else '/user/%s/worklog' %(arec.code) }}">{{_('Worklog')}}</a>
            </li>
            <li class="{{'active' if page=='calendar' else ''}}">
                <a href="{{'#' if page=='calendar' else '/user/%s/calendar' %(arec.code) }}">{{_('Calendar')}}</a>
            </li>
            <!--
            <li class="{{'active' if page=='wiki' else ''}}">
                <a href="{{'#' if page=='wiki' else '/user/%s/wiki' %(arec.code) }}">{{_('Wiki')}}</a>
            </li>
            -->
        </ul>
    </div>
</div>

