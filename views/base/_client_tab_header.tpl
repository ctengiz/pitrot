
<div class="row">
    <div class="col-xs-9">
        <h2 style="margin-top: 0px;">
            {{arec.code}}
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
            <a type="button" href="/admin/client/edit/{{arec.id}}" class="btn btn-primary btn-xs">
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
                <a href="{{'#' if page=='overview' else '/client/%s/overview' %(arec.code)}}">{{_('Overview')}}</a>
            </li>
            <li class="{{'active' if page=='issues' else ''}}">
                <a href="{{'#' if page=='issues' else '/client/%s/issues' %(arec.code) }}">{{_('Issues')}}</a>
            </li>
            <li class="{{'active' if page=='activity' else ''}}">
                <a href="{{'#' if page=='activity' else '/client/%s/activity' %(arec.code) }}">{{_('Activity')}}</a>
            </li>
            <li class="{{'active' if page=='files' else ''}}">
                <a href="{{'#' if page=='files' else '/client/%s/files' %(arec.code) }}">{{_('Files')}}</a>
            </li>
            <li class="{{'active' if page=='worklog' else ''}}">
                <a href="{{'#' if page=='worklog' else '/client/%s/worklog' %(arec.code) }}">{{_('Worklog')}}</a>
            </li>
            <li class="{{'active' if page=='calendar' else ''}}">
                <a href="{{'#' if page=='calendar' else '/client/%s/calendar' %(arec.code) }}">{{_('Calendar')}}</a>
            </li>
            <li class="{{'active' if page=='wiki' else ''}}">
                <a href="{{'#' if page=='wiki' else '/client/%s/wiki' %(arec.code) }}">{{_('Wiki')}}</a>
            </li>
            <li class="{{'active' if page=='forum' else ''}}">
                <a href="{{'#' if page=='forum' else '/client/%s/wiki' %(arec.code) }}">{{_('Forum')}}</a>
            </li>
            <li class="{{'active' if page=='news' else ''}}">
                <a href="{{'#' if page=='news' else '/client/%s/wiki' %(arec.code) }}">{{_('News')}}</a>
            </li>
            <li class="{{'active' if page=='roadmap' else ''}}">
                <a href="{{'#' if page=='roadmap' else '/client/%s/roadmap' %(arec.code) }}">{{_('Roadmap')}}</a>
            </li>
        </ul>
    </div>
</div>

