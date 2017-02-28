% include('_header.tpl')

<div class="row" style="margin-bottom: 5px;">
    <div class="col-md-12">
        <a href="/admin/dfissuestatus/add/0" class="btn btn-success">
            <span class="glyphicon glyphicon-plus"></span>
            {{_('Add New Status')}}
        </a>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <table class="table">
            <tr>
                <td>
                    {{_('ID')}}
                </td>
                <td>
                    {{_('No')}}
                </td>
                <td>
                    {{_('Code')}}
                </td>
                <td>
                    {{_('Issue Closed')}}
                </td>
                <td>
                    {{_('Operations')}}
                </td>
            </tr>

            % for rw in alst:
            <tr>
                <td>
                    {{rw.id}}
                </td>
                <td>
                    {{rw.nro}}
                </td>
                <td>
                    {{rw.code}}
                </td>
                <td style="text-align: center; width: 70px;">
                    {{! '<span class="glyphicon glyphicon-ok"></span>' if rw.issue_closed else '&nbsp;'}}
                </td>
                <td>
                    <a href="/admin/dfissuestatus/edit/{{rw.id}}" class="btn btn-primary btn-sm" title="{{_('Edit')}}">
                        <span class="glyphicon glyphicon-edit"></span>
                    </a>
                    <a href="/admin/dfissuestatus/del/{{rw.id}}" class="btn btn-danger btn-sm" title="{{_('Delete')}}">
                        <span class="glyphicon glyphicon-trash"></span>
                    </a>
                </td>
            </tr>

            % end
        </table>
    </div>
</div>

% include('_footer.tpl')