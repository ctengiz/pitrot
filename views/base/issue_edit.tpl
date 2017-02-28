% include('_header.tpl')

%if created_id:
<div class="alert alert-success alert-dismissible fade in">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4>
        {{! _('Issue <a href="/issue/%s">#%s</a> has been created successfully' %(created_id, created_id )) }}
    </h4>
</div>
%end

<div class="row">
    <div class="col-sm-12">
        <form class="form-horizontal" role="form" method="post" id="frm-post" enctype="multipart/form-data">
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Title')}}</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="title" value="{{arec.title}}" placeholder="{{_('Title')}}" required>
                </div>
                <div class="col-sm-2">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="is_private" value="1" {{ "checked" if arec.is_private else "" }}> {{_('Private')}}
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Project')}}</label>
                <div class="col-sm-2">
                    <input class="form-control" id="project-id" name="project_id" value="{{arec.project_id}}" required>
                </div>

                <label class="col-sm-2 control-label">{{_('Reporter')}}</label>
                <div class="col-sm-2">
                    <!-- todo: project admin ise başkasının adına da iş açabilmeli -->
                    %if not session['is_admin']:
                        <input type="text" class="form-control" name="usr_code_from" value="{{arec.usr_code_from}}" required readonly>
                        <input class="form-control" name="usr_id_from" value="{{arec.usr_id_from}}" type="hidden">
                    %else:
                        <input class="form-control" name="usr_id_from" value="{{arec.usr_id_from}}" id="usr-id-from">
                    %end

                </div>

                <label class="col-sm-2 control-label">{{_('Assignee')}}</label>
                <div class="col-sm-2">
                    <input class="form-control" name="usr_id_assigned" value="{{arec.usr_id_assigned}}" id="usr-id-assigned">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Date Opened')}}</label>
                <div class="col-sm-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_open" value="{{date_to_str(arec.dt_open)}}" placeholder="{{_('Date opened')}}" required>
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>


                <label class="col-sm-2 control-label">{{_('Due Date')}}</label>
                <div class="col-sm-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_due" value="{{date_to_str(arec.dt_due)}}" placeholder="{{_('Due date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

                <label class="col-sm-2 control-label">{{_('Reference')}}</label>
                <div class="col-sm-2">
                    <input type="text" class="form-control" name="reference" value="{{arec.reference}}" placeholder="{{_('Reference ticket')}}">
                </div>

            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Plan Date')}}</label>
                <div class="col-sm-2">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_plan" value="{{date_to_str(arec.dt_plan)}}" placeholder="{{_('Planned date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

                <label class="col-sm-2 control-label">{{_('Milestone')}}</label>
                <div class="col-sm-2">
                    <select name="milestone_id" class="form-control">
                        <option value="">{{_('Please select')}}</option>
                        %for k in mile:
                        <option value="{{k.id}}" {{ "selected" if arec.milestone_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>


                <label class="col-sm-2 control-label">{{_('Estimated Hours')}} / {{_('% Done')}}</label>
                <div class="col-sm-1">
                    <input type="text" class="form-control" name="estimated_hours" value="{{arec.estimated_hours}}" placeholder="{{_('Estimated Hours')}}">
                </div>

                <!-- <label class="col-sm-1 control-label">{{_('% Done')}}</label> -->
                <div class="col-sm-1">
                    <select name="done_ratio" class="form-control">
                        %for _p in range(0, 110, 10):
                            <option value="{{_p}}">%{{_p}}</option>
                        %end
                    </select>
                </div>

            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Category')}}</label>
                <div class="col-sm-2">
                    <select name="category_id" class="form-control" required>
                        <option value="">{{_('Please select')}}</option>
                        %for k in cats:
                        <option value="{{k.id}}" {{ "selected" if arec.category_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>

                <label class="col-sm-2 control-label">{{_('Status')}}</label>
                <div class="col-sm-2">
                    <select name="status_id" class="form-control" required>
                        <option value="">{{_('Please select')}}</option>
                        %for k in stas:
                        <option value="{{k.id}}" {{ "selected" if arec.status_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>

                <label class="col-sm-2 control-label">{{_('Priority')}}</label>
                <div class="col-sm-2">
                    <select name="priority_id" class="form-control" required>
                        <option value="">{{_('Please select')}}</option>
                        %for k in prit:
                        <option value="{{k.id}}" {{ "selected" if arec.priority_id == k.id else " " }}>{{k.code}}</option>
                        %end
                    </select>
                </div>

            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Description')}}</label>
                <div class="col-sm-10">
                    <div id="summernote"></div>
                    <div style="display: none;">
                        <textarea class="form-control" rows="8" name="description">{{arec.description}}</textarea>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Watchers')}}</label>
                <div class="col-sm-10">
                    %ws = []
                    %for _wt in arec.watchers:
                    %    ws.append(str(_wt.usr_id))
                    %end
                    <input class="form-control" name="watchers" value="{{','.join(ws)}}" id="watchers">
                </div>
            </div>

            <div class="row">
                <div class="col-xs-2 text-right">
                    <strong>{{_('Related Issues')}}</strong>
                </div>

                <div class="col-xs-6">
                    <table id="tbl-rel" class="table table-condensed table-bordered">

                    </table>

                    <div class="form-group form-group-sm" id="div-related-issues-select" style="display: none">
                        <label class="col-sm-1 control-label">{{_('Relation Type')}}</label>
                        <div class="col-sm-2">
                            <select class="form-control col-xs-4" name="_rel_typ" id="_rel-typ">
                                <option value="REL">{{_('Related To')}}</option>
                                <option value="DUP">{{_('Duplicates')}}</option>
                                <option value="PRE">{{_('Precedes')}}</option>
                                <option value="FLW">{{_('Follows')}}</option>
                                <option value="BLK">{{_('Blocks')}}</option>
                                <option value="STW">{{_('Starts With')}}</option>
                                <option value="ENW">{{_('Ends With')}}</option>
                            </select>
                        </div>

                        <label class="col-sm-1 control-label">{{_('Related Issue')}}</label>
                        <div class="col-sm-6">
                            <input class="form-control" id="_rel-issue-id" name="_rel_issue_id">
                        </div>

                        <div class="col-sm-2">
                            <div class="btn-group btn-group-xs">
                                <a href="#" id="rel-confirm" class="btn btn-success">
                                    <i class="glyphicon glyphicon-check"></i>
                                </a>
                                <a href="#" id="rel-cancel" class="btn btn-warning">
                                    <i class="glyphicon glyphicon-remove"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xs-4">
                    <a href="#" id="add-related-issue" class="btn btn-xs btn-primary pull-right" data-title="{{_('Add')}}">
                        <span class="glyphicon glyphicon-plus"></span>&nbsp;{{_('Add')}}
                    </a>
                </div>
            </div>


            <div class="row" style="margin-top: 5px;">
                <div class="col-xs-2 text-right">
                    <strong>{{_('Related Files')}}</strong>
                </div>

                <div class="col-xs-10">
                    % include('_upload_image', imgs=arec.uploads)
                </div>
            </div>

            <div class="panel-footer" style="margin-bottom: 20px;">
                <button type="submit" class="btn btn-primary">
                    <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Create')}}
                </button>
                <button type="submit" class="btn btn-default" name="create_and_continue">
                    <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Create & Continue')}}
                </button>
            </div>

        </form>
    </div>
</div>


%include('_footer.tpl')


<script type="text/javascript">


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


var format_item = function (item) {
    return item.id + '-' + item.code;
};

var do_select2 = function(ainput, adata, multiple, containerClass, formatter) {

    $(ainput).select2({
        placeholder: "{{_('Please select')}}",
        multiple: multiple,
        allowClear: true,
        data:{
            results: adata,
            text:'code'
        },
        formatSelection: formatter,
        formatResult: formatter,
        containerCssClass: containerClass
    });

};

$(document).ready(function(){
    $("#frm-post").validate({});

    $('#summernote').summernote({height: 200});

    $('#frm-post').submit( function() {
        $("textarea[name='description']").val($('#summernote').code());
        return true;
    });

    var rel_ids = [];
    var project_id = "{{arec.project_id}}";
    var project_data;

    $.ajaxSetup({async: false});
    $.post("/ajax/project", "json").done(function(data){
        project_data = eval(data);
    });
    $.ajaxSetup({async: true});

    var usr_data = get_data('usr', project_id);
    var issue_data = get_data('issue', project_id);

    $('#project-id').select2({
        placeholder: "{{_('Please select')}}",
        allowClear: true,
        data:{
            results: project_data,
            text:'code'}
    }).on("change", function(e) {
        project_id = e.val;

        issue_data = get_data('issue', project_id);
        do_select2('#_rel-issue-id', issue_data, false, 'select2-sm');

        usr_data = get_data('usr', project_id);
        do_select2('#usr-id-assigned', usr_data);
        do_select2('#usr-id-from', usr_data);
        do_select2('#watchers', usr_data, true);
    });


    do_select2('#usr-id-assigned', usr_data);
    do_select2('#usr-id-from', usr_data);
    do_select2('#watchers', usr_data, true);
    do_select2('#_rel-issue-id', issue_data, false, 'select2-sm', format_item);



    $("#add-related-issue").click(function(){
        $('#div-related-issues-select').show();
        return false;
    });

    $("#rel-cancel").click(function(){
        $('#div-related-issues-select').hide();
        return false;
    });

    $("#rel-confirm").click(function(){
        var _id = $('#_rel-issue-id').select2("data");
        var _rt = $('#_rel-typ').val();
        var _rt_text = $('#_rel-typ :selected').text();

        //todo: better error display
        if ($.inArray(_id.id, rel_ids) >= 0) {
            alert('Already added !');
            return false;
        }

        rel_ids.push(_id.id);

        var _tr = '<tr id="rel-id-"' + _id.id + '>'
                + '<td><input type="hidden" name="rel_typ" value="' + _rt + '">' + _rt_text + '</td>'
                + '<td><input type="hidden" name="rel_id" value="' + _id.id + '">' + _id.id + ' - ' + _id.code + '</td>'
                + '<td><a href="#" class="btn btn-xs btn-danger rel-remove" data-rel="' + _id.id + '"><i class="glyphicon glyphicon-trash"></i></a></td>'
                + '</tr>';

        $("#tbl-rel").append(_tr);
        return false;
    });

    $("#tbl-rel").on('click', '.rel-remove', function(){
        var _id = String($(this).data('rel'));
        var _pos = $.inArray(_id, rel_ids);
        if ( ~_pos ) rel_ids.splice(_pos, 1);

        $(this).parent('td').parent('tr').remove();
        return false;
    });


});






</script>