% include('_header.tpl')

<div class="row">
    <div class="col-md-12">
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Role Code')}}</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" name="code" value="{{arec.code}}" placeholder="{{_('Role code')}}">
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
