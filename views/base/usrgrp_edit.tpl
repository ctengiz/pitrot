% include('_header.tpl')

<div class="row">
    <div class="col-md-12">
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Group Code')}}</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" name="code" value="{{arec.code}}" placeholder="{{_('Group code')}}">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Members')}}</label>
                <div class="col-sm-7">
                    %ws = []
                    %for _wt in arec.members:
                    %    ws.append(str(_wt.usr_id))
                    %end
                    <input type="hidden" class="form-control" name="members" value="{{','.join(ws)}}" id="members">
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary">
                        <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Save')}}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>



% include('_footer.tpl')

<script type="text/javascript">

$(document).ready(function(){

    var usr_data;
    $.ajaxSetup({async: false});
    $.post(
        "/ajax/usr",
        {},
        "json").done(function(data){usr_data = eval(data);
    });

    function format(item) {
        return item.code;
    };


    $('#members').select2({
        placeholder: "{{_('Please select')}}",
        multiple: true,
        allowClear: true,
        data:{
            results: usr_data,
            text:'code'},
        formatSelection: format,
        formatResult: format
    });

});






</script>