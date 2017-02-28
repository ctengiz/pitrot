% include('_header.tpl')

<form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
    <fieldset>
        <legend>{{_('Account Info')}}</legend>
        <div class="row">
            <div class="col-md-9">
                <div class="form-group">
                    <label class="col-sm-2 control-label">{{_('Username')}} <span class="label label-danger">*</span></label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" name="code" value="{{arec.code}}" placeholder="{{_('Username')}}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label">{{_('Email')}} <span class="label label-danger">*</span></label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" name="email" value="{{arec.email}}" placeholder="{{_('Email')}}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label">{{_('Fullname')}}</label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" name="full_name" value="{{arec.full_name}}" placeholder="{{_('Fullname')}}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-sm-2 control-label">{{_('Statu')}}</label>
                    <div class="col-sm-5">
                        <select class="form-control" name="statu">
                            <option value="1" {{'selected' if arec.statu == 1 else ''}}>{{_('Active')}}</option>
                            <option value="2" {{'selected' if arec.statu == 2 else ''}}>{{_('Waiting Email Conf.')}}</option>
                            <option value="3" {{'selected' if arec.statu == 3 else ''}}>{{_('Waiting Admin Conf.')}}</option>
                            <option value="99" {{'selected' if arec.statu == 99 else ''}}>{{_('Disabled')}}</option>
                        </select>
                    </div>
                </div>



        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-5">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="is_admin" value="1" {{ "checked" if arec.is_admin else "" }} > {{_('Is Admin')}}
                    </label>
                </div>
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-5">
                <div class="checkbox">
                    <label>
                        <input type="checkbox"
                               name="ck_notification_self"
                               value="1"
                               {{ "checked" if arec.ck_notification_self else "" }} >
                        {{_("Send notification emails for updates I've made")}}
                    </label>
                </div>
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-5">
                <div class="checkbox">
                    <label>
                        <input type="checkbox"
                               name="ck_notification_watcher"
                               value="1"
                               {{ "checked" if arec.ck_notification_watcher else "" }} >
                        {{_("Send notification emails for issues I watch")}}
                    </label>
                </div>
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-5">
                <div class="checkbox">
                    <label>
                        <input type="checkbox"
                               name="ck_notification_project"
                               value="1"
                               {{ "checked" if arec.ck_notification_project else "" }} >
                        {{_("Send notification emails for my projects' all issue updates")}}
                    </label>
                </div>
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-5">
                <div class="checkbox">
                    <label>
                        <input type="checkbox"
                               name="ck_notification_public_project"
                               value="1"
                               {{ "checked" if arec.ck_notification_public_project else "" }} >
                        {{_("Send notification emails for public projects' all issue updates")}}
                    </label>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 control-label">{{_('Client')}}</label>
            <div class="col-sm-5">
                <input type="hidden" id="client-id" class="form-control" name="client_id" value="{{arec.client_id}}">
            </div>
        </div>

            </div>

            <div class="col-md-3">
                <img src="..." alt="..." class="img-thumbnail">

            </div>
        </div>

    </fieldset>

    <fieldset>
        <legend>{{_('Assigned Projects')}}</legend>
        <div class="col-sm-4">
            <table class="table table-bordered" id="tbl-project">
                <tr>
                    <th>{{_('Project')}}</th>
                    <th>{{_('Role')}}</th>
                    <th></th>
                </tr>
                <tr>
                    <td>
                        <input type="hidden" class="form-control" id="project_id">
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
                %for rw in arec.projects:
                <tr>
                    <td>
                        <input type="text" class="form-control" name="project_code" value="{{rw.project_code}}" disabled>
                        <input type="hidden" class="form-control" name="project_id" value="{{rw.project_id}}">
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
    </fieldset>

    <fieldset>
        <legend>{{_('Authentication')}}</legend>

        <div class="form-group">
            <label class="col-sm-2 control-label">{{_('Authentication Method')}}</label>
            <div class="col-sm-3">
                <div class="radio">
                    <label>
                        <input type="radio" name="auth_method" id="optionsRadios1" value="0"
                               {{ "checked" if arec.auth_method == 0 else "" }} >
                        By Password
                    </label>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="radio">
                    <label>
                        <input type="radio" name="auth_method" id="optionsRadios2" value="1"
                               {{ "checked" if arec.auth_method == 1 else "" }} >
                        By Activedirectory
                    </label>
                </div>
            </div>
            <label class="col-sm-1 control-label">{{_('DC Name')}}</label>
            <div class="col-sm-2">
                <input type="text" class="form-control" name="dc_name" value="{{arec.dc_name}}" placeholder="{{_('DC Name')}}">
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-2 control-label">{{_('Password')}}</label>
            <div class="col-sm-2">
                <input type="password" class="form-control" name="upass" value="{{arec.upass}}" placeholder="{{_('Password')}}">
            </div>
            <label class="col-sm-2 control-label">{{_('Confirmation')}}</label>
            <div class="col-sm-2">
                <input type="password" class="form-control" name="upass2" value="{{arec.upass}}" placeholder="{{_('Password')}}">
            </div>
            <div class="col-sm-2">
                <a id="generate_password" class="btn btn-warning btn-sm" href="#" rel="tooltip" title="">
                    <span class="glyphicon glyphicon-plus"></span> {{_('Generate Password')}}
                </a>
                <span id="generated" class="muted"></span>
            </div>
            <div class="col-sm-2">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="ck_inform" value="1"> {{_('Send user login info')}}
                    </label>
                </div>
            </div>
        </div>
    </fieldset>

    <div class="panel-footer" style="margin-bottom: 20px;">
        <button type="submit" class="btn btn-primary">
            <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Save')}}
        </button>
    </div>

</form>


<script type="text/template" id="row-template">
    <tr>
        <td>
            <input type="hidden" class="form-control" name="project_id">
            <input type="text" class="form-control" disabled name="project_code">
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

% include('_footer.tpl')


<script type="text/javascript">
    (function($) {

        $.generateRandomPassword = function(limit) {

            limit = limit || 8;
            var password = '';
            var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

            var list = chars.split('');
            var len = list.length, i = 0;

            do {
                i++;
                var index = Math.floor(Math.random() * len);
                password += list[index];
            } while(i < limit);

            return password;
        };
    })(jQuery);

    $(document).ready(function(){
        var client_data;
        var project_data;
        var usrrole_data;

        $.ajaxSetup({async: false});
        $.post("/ajax/client", "json").done(function(data){
            client_data = eval(data);
        });
        $.post("/ajax/project", "json").done(function(data){
            project_data = eval(data);
        });
        $.post("/ajax/usrrole", "json").done(function(data){
            usrrole_data = eval(data);
        });

        function format(item) {
            return item.code;
        };

        $('#client-id').select2({
            placeholder: "{{_('Please select')}}",
            allowClear: true,
            data:{
                results: client_data,
                text:'code'},
            formatSelection: format,
            formatResult: format
        });

        $('#project_id').select2({
            placeholder: "{{_('Please select')}}",
            allowClear: true,
            data:{
                results: project_data,
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

        $('#generate_password').click(function(event) {
            var pwd = $.generateRandomPassword(7);

            /* $('#generated').text(pwd); */
            $("input[name='upass']").val(pwd);
            $("input[name='upass2']").val(pwd);

            event.preventDefault();
        });


        $("#btn-add-role").click(function(){
            /* alert("Selected value is: "+$("#project_id").select2("text")); */
            var id_project = $("#project_id").val();
            var id_usrrole = $("#usrrole_id").val();

            if (id_project && id_usrrole) {
                var code_project = ($.grep(project_data, function(e){ return e.id == id_project; }))[0].code;
                var code_usrrole = ($.grep(usrrole_data, function(e){ return e.id == id_usrrole; }))[0].code;

                $('#tbl-project > tbody:last').append($("#row-template").text());
                $('#tbl-project [name="project_id"]:last').val(id_project);
                $('#tbl-project [name="project_code"]:last').val(code_project);
                $('#tbl-project [name="usrrole_id"]:last').val(id_usrrole);
                $('#tbl-project [name="usrrole_code"]:last').val(code_usrrole);

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