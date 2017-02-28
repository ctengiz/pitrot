% include('_header.tpl')

% include('_project_tab_header.tpl')

<div class="row">
    <div class="col-sm-12">
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tab_category" data-toggle="tab">{{_('Issue Categories')}}</a></li>
            <li><a href="#tab_status" data-toggle="tab">{{_('Issue Statuses')}}</a></li>
            <li><a href="#tab_milestone" data-toggle="tab">{{_('Milestones')}}</a></li>
        </ul>
    </div>
</div>

<div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="tab_category">
        <table class="table-bordered table-condensed table-editable" data-url="/project_category/{{arec.id}}">
            <thead>
            <tr>
                <th>id</th>
                <th>Code</th>
                <th>
                    <button class="btn btn-primary btn-xs row-act-add">
                        <i class="glyphicon glyphicon-plus"></i>
                    </button>
                </th>
            </tr>
            </thead>
            <tbody>
            %for rw in arec.category:
            <tr data-id="{{rw.id}}">
                <td data-field="id" data-val="{{rw.id}}">{{rw.id}}</td>
                <td data-field="code" data-val="{{rw.code}}">{{rw.code}}</td>
                <td>
                    <div class="btn-group btn-group-xs">
                        <button class="btn btn-default row-act-edit">
                            <i class="glyphicon glyphicon-pencil"></i>
                        </button>
                        <button class="btn btn-danger row-act-delete">
                            <i class="glyphicon glyphicon-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
            %end
            </tbody>


            <tr class="row-edit-template" style="display: none;">
                <td data-field="id">
                    <input type="text" class="form-control" readonly value="">
                </td>
                <td data-field="code">
                    <input type="text" class="form-control" value="">
                </td>
                <td>
                    <div class="btn-group btn-group-xs">
                        <button class="btn btn-success row-act-post">
                            <i class="glyphicon glyphicon-ok"></i>
                        </button>

                        <button class="btn btn-warning row-act-cancel">
                            <i class="glyphicon glyphicon-remove"></i>
                        </button>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <!-- BOF Status -->
    <div role="tabpanel" class="tab-pane" id="tab_status">
        <table class="table-bordered table-condensed table-editable" data-url="/project_status/{{arec.id}}">
            <thead>
            <tr>
                <th>id</th>
                <th>Nro</th>
                <th>Code</th>
                <th>Issue Closed</th>
                <th>
                    <button class="btn btn-primary btn-xs row-act-add">
                        <i class="glyphicon glyphicon-plus"></i>
                    </button>
                </th>
            </tr>
            </thead>
            <tbody>
            %for rw in arec.status:
            <tr data-id="{{rw.id}}">
                <td data-field="id" data-val="{{rw.id}}">{{rw.id}}</td>
                <td data-field="nro" data-val="{{rw.nro}}">{{rw.nro}}</td>
                <td data-field="code" data-val="{{rw.code}}">{{rw.code}}</td>
                <td data-field="issue_closed"
                    data-val="{{1 if rw.issue_closed else 0}}"
                    data-render-type="check"
                    class="text-center">
                    {{! '<span class="glyphicon glyphicon-ok"></span>' if rw.issue_closed else '&nbsp;'}}
                </td>
                <td>
                    <div class="btn-group btn-group-xs">
                        <button class="btn btn-default row-act-edit">
                            <i class="glyphicon glyphicon-pencil"></i>
                        </button>
                        <button class="btn btn-danger row-act-delete">
                            <i class="glyphicon glyphicon-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
            %end
            </tbody>


            <tr class="row-edit-template" style="display: none;">
                <td data-field="id">
                    <input type="text" class="form-control" readonly value="">
                </td>
                <td data-field="nro">
                    <input type="text" class="form-control" value="">
                </td>
                <td data-field="code">
                    <input type="text" class="form-control" value="">
                </td>
                <td data-field="issue_closed"
                    data-render-type="check"
                    class="text-center"
                        >
                    <select class="form-control">
                        <option value="0">{{_('No')}}</option>
                        <option value="1">{{_('Yes')}}</option>
                    </select>
                </td>
                <td>
                    <div class="btn-group btn-group-xs">
                        <button class="btn btn-success row-act-post">
                            <i class="glyphicon glyphicon-ok"></i>
                        </button>

                        <button class="btn btn-warning row-act-cancel">
                            <i class="glyphicon glyphicon-remove"></i>
                        </button>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <!-- EOF Status -->



    <!-- BOF Milestone -->
    <div role="tabpanel" class="tab-pane" id="tab_milestone">
        <table class="table-bordered table-condensed table-editable" data-url="/project_milestone/{{arec.id}}">
            <thead>
            <tr>
                <th>id</th>
                <th>Code</th>
                <th>Name</th>
                <th>Planned Date</th>
                <th>Is Active</th>
                <th>Is Released</th>
                <th>
                    <button class="btn btn-primary btn-xs row-act-add">
                        <i class="glyphicon glyphicon-plus"></i>
                    </button>
                </th>
            </tr>
            </thead>
            <tbody>
            %for rw in arec.milestone:
            <tr data-id="{{rw.id}}">
                <td data-field="id" data-val="{{rw.id}}">{{rw.id}}</td>
                <td data-field="code" data-val="{{rw.code}}">{{rw.code}}</td>
                <td data-field="name" data-val="{{rw.name}}">{{rw.name}}</td>
                <td data-field="dt_plan" data-val="{{date_to_str(rw.dt_plan)}}" data-input-type="date">
                    {{date_to_str(rw.dt_plan)}}
                </td>
                <td data-field="is_active"
                    data-val="{{1 if rw.is_active else 0}}"
                    data-render-type="check"
                    class="text-center">
                    {{! '<span class="glyphicon glyphicon-ok"></span>' if rw.is_active else '&nbsp;'}}
                </td>
                <td data-field="is_released"
                    data-val="{{1 if rw.is_released else 0}}"
                    data-render-type="check"
                    class="text-center">
                    {{! '<span class="glyphicon glyphicon-ok"></span>' if rw.is_released else '&nbsp;'}}
                </td>
                <td>
                    <div class="btn-group btn-group-xs">
                        <button class="btn btn-default row-act-edit">
                            <i class="glyphicon glyphicon-pencil"></i>
                        </button>
                        <button class="btn btn-danger row-act-delete">
                            <i class="glyphicon glyphicon-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
            %end
            </tbody>


            <tr class="row-edit-template" style="display: none;">
                <td data-field="id">
                    <input type="text" class="form-control" readonly value="">
                </td>
                <td data-field="code">
                    <input type="text" class="form-control" value="">
                </td>
                <td data-field="name">
                    <input type="text" class="form-control" value="">
                </td>
                <td data-field="dt_plan" data-input-type="date">
                    <div class="date input-group">
                        <input type="text" class="form-control" required>
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </td>
                <td data-field="is_active" data-render-type="check" class="text-center">
                    <select class="form-control">
                        <option value="0">{{_('No')}}</option>
                        <option value="1">{{_('Yes')}}</option>
                    </select>
                </td>
                <td data-field="is_released" data-render-type="check" class="text-center">
                    <select class="form-control">
                        <option value="0">{{_('No')}}</option>
                        <option value="1">{{_('Yes')}}</option>
                    </select>
                </td>
                <td>
                    <div class="btn-group btn-group-xs">
                        <button class="btn btn-success row-act-post">
                            <i class="glyphicon glyphicon-ok"></i>
                        </button>

                        <button class="btn btn-warning row-act-cancel">
                            <i class="glyphicon glyphicon-remove"></i>
                        </button>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <!-- EOF Milestone -->

</div>




<script type="text/template" id="btn-browse">
    <div class="btn-group btn-group-xs">
        <button class="btn btn-default row-act-edit"><i class="glyphicon glyphicon-pencil"></i></button>
        <button class="btn btn-danger row-act-delete"><i class="glyphicon glyphicon-trash"></i></button>
    </div>
</script>


% include('_project_tab_footer.tpl')

% include('_footer.tpl')

<script type="text/javascript">
    var render_cell_value = function(render_type, cell_value) {
        if (!render_type) {
            return cell_value;
        } else if (render_type == 'check') {
            if (cell_value == '1') {
                return '<span class="glyphicon glyphicon-ok"></span>'
            } else {
                return '&nbsp;'
            }
        }
    };

    var get_control_value = function(cell) {
        var input_type = $(cell).data("input-type");
        if (!input_type) {
            var control = cell.children[0];
        } else if (input_type == 'date') {
            var control = $(cell).find("input")[0];
        }
        return $(control).val();
    };

    var set_control_value = function(control, input_type) {
        //
    };

    var get_cell_control = function(cell) {
        var input_type = $(cell).data("input-type");
        if (!input_type) {
            var control = cell.children[0];
        } else if (input_type == 'date') {
            var control = $(cell).find("input")[0];
        }
        return control;
    };

    $(document).ready(function () {

        $(".table-editable").on("click", ".row-act-edit", function() {
            var row = $(this).parents("tr")[0];
            var table = $(this).parents("table")[0];
            var trow = $(table).find("tr.row-edit-template")[0];

            $(row).data("opr", "edit");

            var count = row.children.length - 1;
            for (var ndx = 0; ndx <= count; ndx++) {
                var cell = row.children[ndx];

                if (ndx != count) {
                    var cell_val = $(cell).data("val");
                } else {
                    var cell_val = $(cell).html();
                }

                $(cell).data("old-val", cell_val);

                var template_cell = $(trow.children[ndx])[0];
                var template_control = template_cell.children[0];
                var input_type = $(template_cell).data("input-type");
                var control = $(template_control).clone();

                $(cell).html(control);

                if (input_type == "date") {
                    make_datepicker(control);
                    $(control).datepicker("update", cell_val);
                } else {
                    $(control).val(cell_val);
                }
            }
        });

        $(".table-editable").on("click", ".row-act-add", function() {
            var table = $(this).parents("table")[0];
            var row = $($(table).find("tr.row-edit-template")[0]).clone();
            $(row).appendTo($(table).find("tbody")[0]);

            $(row).data("opr", "add");
            $(row).removeClass("row-edit-template");
            $(row).show();

            //active controls. todo: can be more effective
            make_datepicker($(row).find(".date"));
        });

        $(".table-editable").on("click", ".row-act-cancel", function() {

            var row = $(this).parents("tr")[0];
            var opr = $(row).data("opr");

            var table = $(this).parents("table")[0];

            if (opr == "edit") {
                var count = row.children.length - 1;
                for (var ndx = 0; ndx <= count; ndx++) {
                    var cell = row.children[ndx];

                    if (ndx != count) {
                        $(cell).html(
                                render_cell_value(
                                        $(cell).data('render-type'),
                                        $(cell).data('old-val')
                                )
                        );
                    } else {
                        $(cell).html($(cell).data("old-val"));
                    }
                    $(cell).data("old-val", "");
                }
            } else if (opr == "add") {
                $(row).remove();
            }

        });


        $(".table-editable").on("click", ".row-act-post", function() {

            var row = $(this).parents("tr")[0];
            var opr = $(row).data("opr");

            var table = $(this).parents("table")[0];
            var url = $(table).data("url");

            var vals = [];
            var data = {};
            data["opr"] = opr;

            //collect values
            var count = row.children.length - 1;
            for (var ndx = 0; ndx <= count; ndx++) {
                var cell = row.children[ndx];
                var cell_val = get_control_value(cell);

                //prevent sending last column which contains buttons
                if (ndx < count) {
                    data[$(cell).data("field")] = cell_val;
                }

                vals.push(cell_val);
            }

            $.ajax({
                method: "POST",
                url: url,
                data: data,
                dataType: "json",
                beforeSend: function() {
                    //todo: processing modal
                    //$('#processing-modal').modal('show');
                },
                error: function (e) {
                    //
                }
            }).done(function(rslt, textStatus, jqXH){
                if (rslt.success) {
                    for (var ndx = 0; ndx <= count; ndx++) {

                        var cell = row.children[ndx];

                        if (ndx != count) {
                            var new_val = vals[ndx];
                            if ($(cell).data('field') == 'id' && opr == 'add' ) {
                                new_val = rslt.id;
                                $(row).data('id', rslt.id);
                            }
                            $(cell).html(render_cell_value($(cell).data("render-type"), new_val));
                            $(cell).data("val", new_val)

                        } else {
                            $(cell).html($("#btn-browse").html());
                        }
                    }
                } else {
                    alert(rslt.message);
                }
            }).fail(function(rslt){
                alert(rslt.responseText);
            }).always(function () {
                //todo: processing modal
                //$('#processing-modal').modal('hide');
            });
            return false;
        });

        $(".table-editable").on("click", ".row-act-delete", function() {

            var that = this;

            bootbox.confirm("{{_('Are you sure?')}}", function(confirm) {
                if (confirm) {
                    var row = $(that).parents("tr")[0];
                    var opr = 'del';

                    var table = $(that).parents("table")[0];
                    var url = $(table).data("url");

                    var data = {
                        opr:opr,
                        id:$(row).data('id')
                    };
                    $.ajax({
                        method: "POST",
                        url: url,
                        data: data,
                        dataType: "json",
                        beforeSend: function() {
                            //todo: processing modal
                            //$('#processing-modal').modal('show');
                        },
                        error: function (e) {
                            //
                        }
                    }).done(function(rslt, textStatus, jqXH){
                        if (rslt.success) {
                            $(row).remove();
                        } else {
                            alert(rslt.message);
                        }
                    }).fail(function(rslt){
                        alert(rslt.responseText);
                    }).always(function () {
                        //todo: processing modal
                        //$('#processing-modal').modal('hide');
                    });
                }
            });

            return false;
        });

    });
</script>
