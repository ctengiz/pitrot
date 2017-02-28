% include('_header.tpl')

<div class="row" style="margin-bottom: 5px;">
    <div class="col-sm-12">
        <a href="/admin/user/add/0" class="btn btn-success">
            <span class="glyphicon glyphicon-plus"></span>
            {{_('Add New User')}}
        </a>
    </div>
</div>

<div class="row">
    <div class="col-sm-12">
        <table class="table table-condensed" id="table-usr">
            <thead>
            <tr>
                <th>
                    {{_('User ID')}}
                </th>
                <th>
                    {{_('User Code')}}
                </th>
                <th>
                    {{_('User Name')}}
                </th>
                <th>
                    {{_('Email')}}
                </th>
                <th>
                    {{_('Client')}}
                </th>
                <th>
                    {{_('Is Admin')}}
                </th>
                <th>{{_('Statu')}}</th>
                <th>
                    {{_('Operations')}}
                </th>
            </tr>
            </thead>
            <tfoot>
            <tr>
                <th colspan="15" class="ts-pager form-horizontal">
                    <button type="button" class="btn first"><i class="icon-step-backward glyphicon glyphicon-step-backward"></i></button>
                    <button type="button" class="btn prev"><i class="icon-arrow-left glyphicon glyphicon-backward"></i></button>
                    <span class="pagedisplay"></span> <!-- this can be any element, including an input -->
                    <button type="button" class="btn next"><i class="icon-arrow-right glyphicon glyphicon-forward"></i></button>
                    <button type="button" class="btn last"><i class="icon-step-forward glyphicon glyphicon-step-forward"></i></button>
                    <select class="pagesize input-mini" title="Select page size">
                        <option selected="selected" value="10">10</option>
                        <option value="20">20</option>
                        <option value="30">30</option>
                        <option value="40">40</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                        <option value="100000000">{{_('All')}}</option>
                    </select>
                    <select class="pagenum input-mini" title="Select page number"></select>
                </th>
            </tr>
            </tfoot>

            <tbody>
            % for rw in alst:
            <tr>
                <td>
                    {{rw.id}}
                </td>
                <td>
                    <a href="/user/{{rw.id}}">{{rw.code}}</a>
                </td>
                <td>
                    {{rw.full_name}}
                </td>
                <td>
                    <a href="mailto:{{rw.email}}">{{rw.email}}</a>
                </td>
                <td>
                    <a href="/client/{{rw.client_code}}">{{rw.client_code}}</a>
                </td>
                <td style="text-align: center;">
                    %if rw.is_admin:
                    <span class="glyphicon glyphicon-ok"></span>
                    %end
                </td>
                <td>
                    {{rw.statu_def}}
                </td>
                <td style="text-align: right;">
                    <a href="/admin/user/edit/{{rw.id}}" class="btn btn-primary btn-sm" title="{{_('Edit')}}">
                        <span class="glyphicon glyphicon-edit"></span>
                    </a>
                    <a href="/admin/user/del/{{rw.id}}" class="btn btn-danger btn-sm" title="{{_('Delete')}}">
                        <span class="glyphicon glyphicon-trash"></span>
                    </a>
                </td>
            </tr>
            % end
            </tbody>
        </table>
    </div>
</div>

% include('_footer.tpl')


<script type="text/javascript">


$(function() {
    // call the tablesorter plugin and apply the uitheme widget
    $("#table-usr").tablesorter({
        // this will apply the bootstrap theme if "uitheme" widget is included
        // the widgetOptions.uitheme is no longer required to be set
        theme : "bootstrap",

        widthFixed: true,

        headerTemplate : '{content} {icon}', // new in v2.7. Needed to add the bootstrap icon!

        // widget code contained in the jquery.tablesorter.widgets.js file
        // use the zebra stripe widget if you plan on hiding any rows (filter widget)
        widgets : [ "uitheme", "filter", "zebra" ],

        widgetOptions : {
            // using the default zebra striping class name, so it actually isn't included in the theme variable above
            // this is ONLY needed for bootstrap theming if you are using the filter widget, because rows are hidden
            zebra : ["even", "odd"],

            // reset filters button
            filter_reset : ".reset"

            // set the uitheme widget to use the bootstrap theme class names
            // this is no longer required, if theme is set
            // ,uitheme : "bootstrap"

        }
    })
            .tablesorterPager({

                // target the pager markup - see the HTML block below
                container: $(".ts-pager"),

                // target the pager page select dropdown - choose a page
                cssGoto  : ".pagenum",

                // remove rows from the table to speed up the sort of large tables.
                // setting this to false, only hides the non-visible rows; needed if you plan to add/remove rows with the pager enabled.
                removeRows: false,

                // output string - default is '{page}/{totalPages}';
                // possible variables: {page}, {totalPages}, {filteredPages}, {startRow}, {endRow}, {filteredRows} and {totalRows}
                output: '{startRow} - {endRow} / {filteredRows} ({totalRows})',

                size: 30


            });

});

</script>