% setdefault('imgs', [])
% setdefault('file_col', 12)
<div class="row">
    <div class="col-sm-10">
        <div class="row" id="div-img-list">
            % for img in imgs:
            <div class="col-sm-{{file_col}}">
                <div class="row">
                    <div class="col-xs-2" style="text-align: right;">
                        <img src="/uploads/th_{{img.uuid}}" class="img-thumbnail">
                    </div>
                    <div class="col-xs-6">
                        <label>{{img.file_name}}</label>
                        <input type="text" class="form-control input-sm" name="upload_defi" value="{{img.defi}}">
                    </div>
                    <div class="col-xs-1">
                        <button type="button" class="btn btn-xs btn-danger btn-del-img" style="margin-top: 35px;">
                            <span class="glyphicon glyphicon-trash"></span>
                        </button>
                    </div>
                </div>
                <input type="file" name="picture_load" style="visibility:hidden" value="{{img.file_name}}">
                <input type="hidden" name="upload_id" value="{{img.upload_id}}">
                <hr/>
            </div>
            % end
        </div>
    </div>
    <div class="col-sm-2">
        <button type="button" class="btn btn-xs btn-success pull-right" id="btn-add-img">
            <span class="glyphicon glyphicon-picture"></span>
            {{_('Add File/Picture')}}
        </button>
    </div>

</div>


<script type="text/template" id="row-template">
    <div class="col-sm-{{file_col}}" style="display: none;">
        <div class="row">
            <div class="col-xs-2" style="text-align: right;">
                <img src="holder.js/100x100" class="img-thumbnail" >
            </div>
            <div class="col-xs-6">
                <label></label>
                <input type="text" class="form-control input-sm" name="upload_defi" placeholder="{{_('File description')}}">
            </div>
            <div class="col-xs-1">
                <button type="button" class="btn btn-xs btn-danger btn-del-img" style="margin-top: 25px;">
                    <span class="glyphicon glyphicon-trash"></span>
                </button>
            </div>
        </div>
        <input type="file" name="picture_load" style="visibility:hidden" >
        <input type="hidden" name="upload_id" value="0">
    </div>
</script>


<script type="text/javascript">
$(document).ready(function(){

    $('#btn-add-img').click(function(){
        $('#div-img-list').append($("#row-template").text());

        /* $('#div-img-list > div:last').hide(); */

        $('#div-img-list [name="picture_load"]:last').click();

    });

    $("#div-img-list").on('click', '.btn-del-img', function(){
        $(this).parent('div').parent('div').parent('div').remove();
        return false;
    });

    $('#div-img-list').on('change', '[name="picture_load"]', function(e){
        if (e.target.files === undefined) e.target.files = e.target && e.target.value ? [ {name: e.target.value.replace(/^.+\\/, '')} ] : []
        if (e.target.files.length === 0) {
            $('#div-img-list > div:last').remove();
            return false;
        }

        $('#div-img-list > div:last').show();

        var file = e.target.files[0];

        if (typeof file.type !== "undefined" ? file.type.match('image.*') : file.name.match(/\.(gif|png|jpe?g)$/i)
                && typeof FileReader !== "undefined")
        {
            var reader = new FileReader();

            reader.onload = function(re) {
                var $img = $('#div-img-list img:last').attr('src', re.target.result);
                e.target.files[0].result = re.target.result
            };

            reader.readAsDataURL(file)
        } else {
            $('#div-img-list img:last').attr('data-src', "holder.js/100x75/text:" + file.name);
            Holder.run();
        }
        $('#div-img-list label:last').text(file.name);
    });
})

</script>