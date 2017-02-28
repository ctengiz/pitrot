% include('_header.tpl')

% include('_user_tab_header.tpl')

<div class="row" style="margin-top: 5px;">
    <input type="hidden" value="{{arec.id}}" id="cal-usr_id">
    <div class="col-sm-12">
        <div id="calendar"></div>
    </div>
</div>

% include('_user_tab_footer.tpl')

% include('_footer.tpl')

