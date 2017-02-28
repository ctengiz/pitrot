% include('_header.tpl')

% include('_project_tab_header.tpl')

<div class="row" style="margin-top: 5px;">
    <div class="col-xs-4">
        <div id="div-upload-file">
            {{_('Upload File')}}
        </div>
    </div>
    <div class="col-xs-8">
        <ul class="list-group" id="ul-file-list">
            %for rw in arec.uploads:
                <li class="list-group-item">
                    <div class="row">
                        <div class="col-sm-1"></div>
                        <div class="col-sm-9" id="{{rw.id}}">
                            <a href="/uploads/{{rw.uuid}}">
                                {{rw.file_name}}
                            </a>
                            &nbsp;
                            {{rw.defi}}
                        </div>
                        <div class="col-sm-2">
                            <div class="pull-right">
                                <!-- todo: file operations -->
                                <a href="/project_file_update/{{arec.id}}/{{rw.upload_id}}"><span class="glyphicon glyphicon-pencil"></span></a>
                                <a href="/project_file_delete/{{arec.id}}/{{rw.upload_id}}" style="margin-left: 5px; color: rgb(209, 91, 71);"><span class="glyphicon glyphicon-trash"></span></a>
                            </div>
                        </div>
                    </div>
                </li>
            %end
        </ul>
    </div>
</div>

% include('_project_tab_footer.tpl')

% include('_footer.tpl')

<script type="text/template" id="file-row-template">
    <li class="list-group-item">
        <div class="row">
            <div class="col-sm-1"></div>
            <div class="col-sm-9">
                <a href="/uploads/__file_uuid__">
                    __file_name__
                </a>
                &nbsp;
                <!-- todo: __file_defi__ -->
            </div>
            <div class="col-sm-2">
                <div class="pull-right">
                    <!-- todo: file operations -->
                    <a href="/project_file_update/{{arec.id}}/__file_id__"><span class="glyphicon glyphicon-pencil"></span></a>
                    <a href="/project_file_delete/{{arec.id}}/__file_id__" style="margin-left: 5px; color: rgb(209, 91, 71);"><span class="glyphicon glyphicon-trash"></span></a>
                </div>
            </div>
        </div>
    </li>
</script>

<script type="text/javascript">
    $(document).ready(function(){
        $("#div-upload-file").uploadFile({
            url: "/project_file_upload/{{arec.id}}",
            fileName: "afile",
            showDone: false,
            showStatusAfterSuccess: false,
            returnType: 'json',
            uploadButtonClass: 'btn btn-success',
            dragDropStr:'<span class="text-muted">&nbsp; {{_("File Drop Area")}}</span>',
            onSuccess:function(files, data, xhr){
            	//files: list of files
            	//data: response from server
            	//xhr : jquer xhr object
                if (data.success) {
                    var arow = $("#file-row-template").text()
                                    .replace('__file_name__', files[0])
                                    .replace('__file_id__', data.upload_id)
                                    .replace('__file_uuid__', data.uuid)
                            ;
                    $('#ul-file-list').prepend(arow);

                } else {
                    alert(data.message);
                }
            }
        });
    });
</script>
