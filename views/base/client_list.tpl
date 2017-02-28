% include('_header.tpl')

<div class="row" style="margin-bottom: 5px;">
    <div class="col-sm-12">
        <a href="/admin/client/add/0" class="btn btn-success">
            <span class="glyphicon glyphicon-plus"></span>
            {{_('Add New Client')}}
        </a>
    </div>
</div>

<div class="row">
    <div class="col-sm-12">
        <table class="table">
            <thead>
            <tr>
                <th>
                    {{_('ID')}}
                </th>
                <th>
                    {{_('Code')}}
                </th>
                <th>
                    {{_('Name')}}
                </th>
                <th>
                    {{_('Projects')}}
                </th>
                <th>
                    {{_('Users')}}
                </th>
                <!--
                <td>
                    {{_('Is Public')}}
                </td>
                <td>
                    {{_('Is Active')}}
                </td>
                <td>
                    {{_('Client')}}
                </td>
                -->
                <td>
                    {{_('Operations')}}
                </td>
            </tr>
            </thead>

            <tbody>
            % for rw in alst:
            <tr>
                <td>
                    <a href="/client/{{rw.code}}">{{rw.id}}</a>
                </td>
                <td>
                    <a href="/client/{{rw.code}}">{{rw.code}}</a>
                </td>
                <td>
                    {{rw.name}}
                </td>
                <td>
                    %for urw in rw.projects:
                    <a href="/project/{{urw.code}}" class="btn btn-xs btn-warning" style="margin-bottom: 2px;">{{urw.code}}</a>
                    %end
                </td>
                <td>
                    %for urw in rw.users:
                    <a href="/user/{{urw.id}}" class="btn btn-xs btn-info" style="margin-bottom: 2px;">{{urw.code}}</a>
                    %end
                </td>
                <td>
                    <a href="/admin/client/edit/{{rw.id}}" class="btn btn-primary btn-sm" title="{{_('Edit')}}">
                        <span class="glyphicon glyphicon-edit"></span>
                    </a>
                    <a href="/admin/client/del/{{rw.id}}" class="btn btn-danger btn-sm" title="{{_('Delete')}}">
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