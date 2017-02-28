% include('_header.tpl')

<div class="row" style="margin-bottom: 5px;">
    <div class="col-sm-12">
        <a href="/worklog/add" class="btn btn-success">
            <span class="glyphicon glyphicon-time"></span>
            {{_('Worklog')}}
        </a>
    </div>
</div>

% include('_list_worklog.tpl')

% include('_footer.tpl')

% include('_tablesorter_js.tpl')