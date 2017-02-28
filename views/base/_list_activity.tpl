<table class="table">
    <tbody>
    %for rw in alst:
        <%
        alink = '#'
        atitle = rw.title
        _typ = rw.update_type.strip()
        if _typ == 'issue_new':
            alink = '/issue/%d?project=%s' %(rw.issue_id, rw.project_code)
        elif _typ == 'issue_update':
            alink = '/issue/%d?project=%s#chg%d' %(rw.issue_id, rw.project_code, rw.rel_id)
        elif _typ == 'issue_comment':
            alink = '/issue/%d?project=%s#com%d' %(rw.issue_id, rw.project_code, rw.rel_id)
        elif _typ == 'issue_upload':
            alink = '/issue/%d?project=%s#upl%d' %(rw.issue_id, rw.project_code, rw.rel_id)
        elif _typ == 'worklog':
            alink = '/project/%s/worklog#%d' %(rw.project_code, rw.rel_id)
        elif _typ == 'project_upload':
            alink = '/project/%s/files#%d' %(rw.project_code, rw.rel_id)
            atitle = rw.file_name
        end %>
        <tr>
            <td>
                {{date_to_str(rw.dttm)}}
            </td>
            <td>
                <a href="{{alink}}">{{rw.update_type}}</a>
            </td>
            <td>
                <a href="/project/{{rw.project_code}}">{{rw.project_code}}</a>
            </td>
            <td>
                %if rw.issue_id:
                    <a href="/issue/{{rw.issue_id}}">{{rw.title}}</a>
                %else:
                    <a href="/uploads/{{rw.uuid}}">{{rw.file_name}}</a>
                %end

            </td>
            <td>
                <a href="/user/{{rw.usr_id}}">{{rw.usr_code}}</a>
            </td>
        </tr>
    %end
    </tbody>
</table>
