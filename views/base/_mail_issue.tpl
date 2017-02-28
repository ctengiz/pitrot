<style type="text/css">
    body {
        font-family: verdana,arial,sans-serif;
        font-size:11px;
    }
    table {
        font-size:11px;
        color:#333333;
        border-width: 1px;
        border-color: #666666;
        border-collapse: collapse;
    }
    table th {
        border-width: 1px;
        padding: 8px;
        border-style: solid;
        border-color: #666666;
        background-color: #dedede;
        text-align: right;
    }
    table td {
        border-width: 1px;
        padding: 8px;
        border-style: solid;
        border-color: #666666;
        background-color: #ffffff;
    }
</style>

%if act == 'edit':
<h1>{{_('Issue')}}
    <a href="http://{{config['general.site_url']}}/issue/view/{{arec.id}}">#{{arec.id}}</a>
    {{_('Updated')}}
</h1>
%else:
<h1>
    {{_('New Issue Reported')}} :
    <a href="http://{{config['general.site_url']}}/issue/view/{{arec.id}}">
        #{{arec.id}}
    </a>
</h1>
%end

<h2>
    <a href="http://{{config['general.site_url']}}/issue/view/{{arec.id}}">
        {{arec.title}}
    </a>
    &nbsp;
    <small>
        <a href="http://{{config['general.site_url']}}/project/{{arec.project_code}}">
            [{{arec.project_code}}]
        </a>
    </small>
</h2>

%if act == 'add':
<table border="1" >
    <tr><th>{{_('Reported By')}}</th><td>{{arec.usr_code_from}}</td></tr>
    <tr><th>{{_('Assignee')}}</th><td>{{arec.usr_code_assigned}}</td></tr>
    <tr><th>{{_('Category')}}</th><td>{{arec.category}}</td></tr>
    <tr><th>{{_('Priority')}}</th><td>{{arec.priority}}</td></tr>
    <tr><th>{{_('Status')}}</th><td>{{arec.status}}</td></tr>
    <tr><th>{{_('Plan Date')}}</th><td>{{date_to_str(arec.dt_plan)}}</td></tr>
    <tr><th>{{_('Estimated Hours')}}</th><td>{{arec.estimated_hours}}</td></tr>
    <tr><th>{{_('Due Date')}}</th><td>{{date_to_str(arec.dt_due)}}</td></tr>
    <tr><th>{{_('Due Date')}}</th><td>{{date_to_str(arec.dt_due)}}</td></tr>
    <tr>
        <th colspan="2">
            <h1>{{_('Description')}}</h1>
        </th>
    </tr>
    <tr>
        <td colspan="2">{{!arec.description}}</td>
    </tr>
</table>
%end

%if act == 'edit':
% _cm = arec.changes[len(arec.changes) - 1]

<h3>
    {{_('Updated by')}} <a href="/user/{{_cm.usr_id}}">{{_cm.usr_code}}</a> on {{date_to_str(_cm.zlins_dttm)}}
</h3>

<table border="1">
    %if _cm.comments:
    <tr>
        <th>{{_('Comment Added')}}</th>
        <td>{{!_cm.comments[0].comment}}</td>
    </tr>
    %end

    %if _cm.uploads:
    <tr>
        <th>{{_('Files Added')}}</th>
        <td>
            <ul>
                %for _fl in _cm.uploads:
                <li>{{_fl.file_name}}</li>
                %end
            </ul>
        </td>
    </tr>
    %end

    %if _cm.logs:
    <tr>
        <th>{{_('Updates')}}</th>
        <td>
            <ul>
                %for _ll in _cm.logs:
                <li>{{_ll.caption}} : {{!_ll.old_val_text}} -> {{!_ll.new_val_text}}</li>
                %end
            </ul>
        </td>
    </tr>
    %end
</table>
%end

<p style="color: rosybrown; margin-top: 10px; border: 1px solid; padding: 3px 5px;">
    Bu e-posta size, mesaja konu olan projeyi takip ettiğiniz veya projede görev aldığınız için iletilmiştir.
    Bu e-postaya cevap vermeyiniz. Bu e-postaya vereceğiniz cevaplar <b>değerlendirilmemektedir</b>.
    <br/>
    Konuyla ilgili yorumlarınızı <a href="{{config['general.site_url']}}">{{config['general.site_title']}}</a> üzerinden
    hesabınız ile giriş yaparak yazabilirsiniz.
    E-posta ile bilgilendirme ayarlarınızı <a href="{{config['general.site_url']}}/myaccount">{{config['general.site_title']}}</a>
    adresinden yapabilirsiniz.
</p>