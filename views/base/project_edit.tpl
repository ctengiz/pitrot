% include('_header.tpl')

<div class="row">
    <div class="col-sm-12">
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Project Code')}}</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" name="code" value="{{arec.code}}" placeholder="{{_('Project code')}}">
                </div>
            </div>

            <!--
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Parent Project')}}</label>
                <div class="col-sm-3">
                    <input id="parent-code" type="text" class="form-control" name="parent-code" value="{{arec.parent_code}}" placeholder="{{_('Parent project code')}}">
                    <input type="hidden" id="parent-id" name="parent_id" value="{{arec.parent_id}}">
                </div>
            </div>
            -->
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Name')}}</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="name" value="{{arec.name}}" placeholder="{{_('Project name')}}">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Parent Project')}}</label>
                <div class="col-sm-3">
                    <input type="hidden" id="parent-id" class="form-control" name="parent_id" value="{{arec.parent_id}}">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Client')}}</label>
                <div class="col-sm-3">
                    <input type="hidden" id="client-id" class="form-control" name="client_id" value="{{arec.client_id}}">
                </div>
            </div>


            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Start Date')}}</label>
                <div class="col-sm-3">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_start" value="{{arec.dt_start}}" placeholder="{{_('Start date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

                <label class="col-sm-2 control-label">{{_('Finish Date')}}</label>
                <div class="col-sm-3">
                    <div class="date input-group">
                        <input type="text" class="form-control" name="dt_finish" value="{{arec.dt_finish}}" placeholder="{{_('Finish date')}}">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>
            </div>

            <div class="form-group">
               <div class="col-sm-offset-2 col-sm-2">
                   <div class="checkbox">
                       <label>
                           <input type="checkbox" name="is_public" value="1" {{ "checked" if arec.is_public else "" }} > {{_('Is Public')}}
                       </label>
                   </div>
               </div>

                <div class="col-sm-offset-2 col-sm-2">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="is_active" value="1" {{ "checked" if arec.is_active else "" }} > {{_('Is Active')}}
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Notes')}}</label>
                <div class="col-sm-8">
                    <textarea class="form-control" rows="4" name="notes">{{arec.notes}}</textarea>
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Members')}}</label>
                <div class="col-sm-6">
                <table class="table table-bordered" id="tbl-project">
                    <tr>
                        <th>{{_('User')}}</th>
                        <th>{{_('Role')}}</th>
                        <th></th>
                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" class="form-control" id="usr_id">
                        </td>
                        <td>
                            <input type="hidden" class="form-control" id="usrrole_id">
                        </td>
                        <td>
                            <a href="#" id="btn-add-role" class="btn btn-success btn-xs" title="{{_('Add')}}...">
                                <span class="glyphicon glyphicon-plus"></span>
                            </a>
                        </td>
                    </tr>
                    <tbody>
                    %for rw in arec.users:
                    <tr>
                        <td>
                            <input type="text" class="form-control" name="usr_code" value="{{rw.usr_code}}" disabled>
                            <input type="hidden" class="form-control" name="usr_id" value="{{rw.usr_id}}">
                        </td>
                        <td>
                            <input type="text" class="form-control" name="usrrole_id" value="{{rw.usrrole_code}}" disabled>
                            <input type="hidden" class="form-control" name="usrrole_id" value="{{rw.usrrole_id}}">
                        </td>
                        <td>
                            <a href="#" class="btn btn-danger btn-xs btn-del-role" title="{{_('Remove')}}...">
                                <span class="glyphicon glyphicon-trash"></span>
                            </a>
                        </td>
                    </tr>
                    %end
                    </tbody>
                </table>

                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary">
                        <span class="glyphicon glyphicon-save"></span> {{_('Save')}}
                    </button>
                    <a type="button" class="btn btn-warning" href="/project">
                        <span class="glyphicon glyphicon-remove"></span> {{_('Cancel')}}
                    </a>
                </div>
            </div>


        </form>
    </div>
</div>

%include('_footer.tpl')

<script type="text/template" id="row-template">
    <tr>
        <td>
            <input type="hidden" class="form-control" name="usr_id">
            <input type="text" class="form-control" disabled name="usr_code">
        </td>
        <td>
            <input type="hidden" class="form-control" name="usrrole_id">
            <input type="text" class="form-control disabled" disabled name="usrrole_code">
        </td>
        <td>
            <a href="#" class="btn btn-danger btn-xs btn-del-role" title="{{_('Remove')}}...">
                <span class="glyphicon glyphicon-trash"></span>
            </a>
        </td>
    </tr>
</script>


<script type="text/javascript">
$(document).ready(function(){

    var client_data;
    var project_data;
    var user_data;
    var usrrole_data;
    $.ajaxSetup({async: false});
    $.post("/ajax/client", "json").done(function(data){ client_data = eval(data); });
    $.post("/ajax/project", "json").done(function(data){ project_data = eval(data); });
    $.post("/ajax/usr", "json").done(function(data){ user_data = eval(data); });
    $.post("/ajax/usrrole", "json").done(function(data){ usrrole_data = eval(data); });
    $.ajaxSetup({async: true});

    function format(item) {
        return item.code;
    };

    $('#parent-id').select2({
        placeholder: "{{_('Please select')}}",
        allowClear: true,
        data:{
            results: project_data,
            text:'code'},
        formatSelection: format,
        formatResult: format
    });

    $('#client-id').select2({
        placeholder: "{{_('Please select')}}",
        allowClear: true,
        data:{
            results: client_data,
            text:'code'},
        formatSelection: format,
        formatResult: format
    });

    $('#usr_id').select2({
        placeholder: "{{_('Please select')}}",
        allowClear: true,
        data:{
            results: user_data,
            text:'code'},
        formatSelection: format,
        formatResult: format
    });

    $('#usrrole_id').select2({
        placeholder: "{{_('Please select')}}",
        allowClear: true,
        data:{
            results: usrrole_data,
            text:'code'},
        formatSelection: format,
        formatResult: format
    });

    $("#btn-add-role").click(function(){
        /* alert("Selected value is: "+$("#project_id").select2("text")); */
        var id_usr = $("#usr_id").val();
        var id_usrrole = $("#usrrole_id").val();

        if (id_usr && id_usrrole) {
            var code_usr = ($.grep(user_data, function(e){ return e.id == id_usr; }))[0].code;
            var code_usrrole = ($.grep(usrrole_data, function(e){ return e.id == id_usrrole; }))[0].code;

            $('#tbl-project > tbody:last').append($("#row-template").text());
            $('#tbl-project [name="usr_id"]:last').val(id_usr);
            $('#tbl-project [name="usr_code"]:last').val(code_usr);
            $('#tbl-project [name="usrrole_id"]:last').val(id_usrrole);
            $('#tbl-project [name="usrrole_code"]:last').val(code_usrrole)

        } else {
            alert("{{_('Invalid selection')}} !");
        }
        return false;

    });

    $("#tbl-project").on('click', '.btn-del-role', function(){
        $(this).parent('td').parent('tr').remove();
        return false;
    });


})


</script>