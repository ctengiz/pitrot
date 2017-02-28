% include('_header.tpl')

<div class="row" style="margin-bottom: 5px;">
    <div class="col-md-12">
        <a href="/admin/usrgrp/add/0" class="btn btn-success">
            <span class="glyphicon glyphicon-plus"></span>
            {{_('Add New Group')}}
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
                    {{_('Code')}}
                </td>
                <td>
                    {{_('Members')}}
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
                    {{rw.code}}
                </td>
                <td>
                    %for k in rw.members:
                    <!-- <span class="label label-default">{{k.usr_code}}</span>-->
                    <span class="bg-info">{{k.usr_code}}</span>&nbsp;
                    %end
                </td>
                <td>
                    <a href="/admin/usrgrp/edit/{{rw.id}}" class="btn btn-primary btn-sm" title="{{_('Edit')}}">
                        <span class="glyphicon glyphicon-edit"></span>
                    </a>
                    <a href="/admin/usrgrp/del/{{rw.id}}" class="btn btn-danger btn-sm" title="{{_('Delete')}}">
                        <span class="glyphicon glyphicon-trash"></span>
                    </a>
                </td>
            </tr>

            % end
        </table>
    </div>
</div>

% include('_footer.tpl')