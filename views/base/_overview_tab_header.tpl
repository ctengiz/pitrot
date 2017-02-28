
<div class="row">
    <div class="col-xs-9">
    </div>
    <div class="col-xs-3">
        <div class="pull-right">

            <!-- todo: yetki kontrolü -->
            <a type="button" href="/issue/add}" class="btn btn-warning btn-xs">
                <span class="glyphicon glyphicon-bullhorn"></span>&nbsp;{{_('New Issue')}}
            </a>

            <!-- todo : yetki kontrolü -->
            <a type="button" href="/worklog/add" class="btn btn-info btn-xs">
                <span class="glyphicon glyphicon-time"></span>&nbsp;{{_('Worklog')}}
            </a>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-sm-12">
        <ul class="nav nav-tabs">
            <li class="{{'active' if page=='overview' else ''}}">
                <a href="{{'#' if page=='overview' else '/overview/overview' }}">{{_('Overview')}}</a>
            </li>
            <li class="{{'active' if page=='issues' else ''}}">
                <a href="{{'#' if page=='issues' else '/overview/issues'  }}">{{_('Issues')}}</a>
            </li>
            <li class="{{'active' if page=='activity' else ''}}">
                <a href="{{'#' if page=='activity' else '/overview/activity'  }}">{{_('Activity')}}</a>
            </li>
            <li class="{{'active' if page=='files' else ''}}">
                <a href="{{'#' if page=='files' else '/overview/files'  }}">{{_('Files')}}</a>
            </li>
            <li class="{{'active' if page=='worklog' else ''}}">
                <a href="{{'#' if page=='worklog' else '/overview/worklog'  }}">{{_('Worklog')}}</a>
            </li>
            <li class="{{'active' if page=='calendar' else ''}}">
                <a href="{{'#' if page=='calendar' else '/overview/calendar'  }}">{{_('Calendar')}}</a>
            </li>
            <li class="{{'active' if page=='wiki' else ''}}">
                <a href="{{'#' if page=='wiki' else '/overview/wiki'  }}">{{_('Wiki')}}</a>
            </li>
            <li class="{{'active' if page=='forum' else ''}}">
                <a href="{{'#' if page=='forum' else '/overview/wiki'  }}">{{_('Forum')}}</a>
            </li>
            <li class="{{'active' if page=='news' else ''}}">
                <a href="{{'#' if page=='news' else '/overview/wiki'  }}">{{_('News')}}</a>
            </li>
            <li class="{{'active' if page=='roadmap' else ''}}">
                <a href="{{'#' if page=='roadmap' else '/overview/roadmap'  }}">{{_('Roadmap')}}</a>
            </li>
        </ul>
    </div>
</div>

