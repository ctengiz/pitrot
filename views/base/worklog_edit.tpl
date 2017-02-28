% include('_header.tpl')

<div class="row">
    <div class="col-sm-12">
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data" id="frm-post">
            <div class="form-group">
                <!-- todo: ancak project admin başkası adına worklog işleyebilir veya yetkisi olan biris-->
                <label class="col-sm-2 control-label">{{_('User')}}</label>
                <div class="col-sm-2">
                    <input class="form-control" name="usr_id" value="{{arec.usr_id}}" id="usr-id" required>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Project')}}</label>
                <div class="col-sm-2">
                    <input class="form-control" id="project-id" name="project_id" value="{{arec.project_id}}" required>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Issue #')}}</label>
                <div class="col-sm-10">
                    <input class="form-control" id="issue-id" name="issue_id" value="{{arec.issue_id}}">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Date')}}</label>
                <div class="col-sm-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt" value="{{date_to_str(arec.dt)}}" placeholder="{{_('Date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Start / Stop Time')}}</label>
                <div class="col-sm-2">
                    <div class="time input-group">
                        <input type="text" class="form-control" name="tm_st" placeholder="{{_('Start time')}}" value="{{arec.tm_st}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-time"></span>
                        </span>
                    </div>
                </div>
                <!--<label class="col-sm-2 control-label">{{_('Finish')}}</label>-->
                <div class="col-sm-2">
                    <div class="time input-group">
                        <input type="text" class="form-control" name="tm_fn" placeholder="{{_('Stop time')}}" value="{{arec.tm_fn}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-time"></span>
                        </span>
                    </div>


                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Description')}}</label>
                <div class="col-sm-10">
                    <textarea name="description" class="form-control">{{arec.description}}</textarea>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Location')}}</label>
                <div class="col-sm-10">
                    <input type="text" name="location" class="form-control" value="{{arec.location}}">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Bill to Client')}}</label>
                <div class="col-sm-2">
                        <input type="checkbox" name="bill_to_client" value="1" {{ "checked" if arec.bill_to_client else "" }}>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary">
                        <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Save')}}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>


% include('_footer.tpl')

<script type="text/javascript">

    var format_item = function (item) {
        return item.code;
    };

    var do_select2 = function(ainput, adata, multiple) {
        $(ainput).select2({
            placeholder: "{{_('Please select')}}",
            multiple: multiple,
            allowClear: true,
            data:{
                results: adata,
                text:'code'},
            formatSelection: format_item,
            formatResult: format_item
        });
    };

    var get_data = function(typ, project_id) {
        var adata;

        $.ajaxSetup({async: false});
        $.post("/ajax/" + typ,
                {"project_id": project_id},
                "json").done(function(data){
                    adata = eval(data);
        });
        $.ajaxSetup({async: true});

        return adata;
    };

    $(document).ready(function(){
        $("#frm-post").validate({});


        var project_id = "{{arec.project_id}}";
        var project_data;

        $.ajaxSetup({async: false});
        $.post("/ajax/project", "json").done(function(data){
            project_data = eval(data);
        });
        var usr_data = get_data('usr', project_id);
        var issue_data = get_data('issue', project_id);
        $.ajaxSetup({async: true});

        $('#project-id').select2({
            placeholder: "{{_('Please select')}}",
            allowClear: true,
            data:{
                results: project_data,
                text:'code'},
            formatSelection: format_item,
            formatResult: format_item
        }).on("change", function(e) {
            project_id = e.val;
            issue_data = get_data('issue', project_id);
            do_select2('#issue-id', issue_data);

            usr_data = get_data('usr', project_id);
            do_select2('#usr-id', usr_data);
        });

        do_select2('#usr-id', usr_data);
        do_select2('#issue-id', issue_data);


    });
</script>