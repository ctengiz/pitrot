{{arec.title}}
<br/>
{{_('Due Date')}} : {{date_to_str(arec.dt_due)}}
<br/>
{{_('Priority')}} : {{arec.priority}}
<br/>
{{_('Status')}} : {{arec.status}}
<br/>
{{_('Reporter')}} : <a href="/user/{{arec.usr_code_from}}">{{arec.usr_code_from}}</a>
