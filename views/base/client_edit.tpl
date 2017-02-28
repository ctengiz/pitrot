% include('_header.tpl')

<div class="row">
    <div class="col-sm-12">
        <form class="form-horizontal" role="form" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Client Code')}}</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" name="code" value="{{arec.code}}" placeholder="{{_('Client code')}}">
                </div>
            </div>

            <div class="form-group">
                <label class="col-sm-2 control-label">{{_('Name')}}</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="name" value="{{arec.name}}" placeholder="{{_('Client name')}}">
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-default">
                        <span class="glyphicon glyphicon-floppy-disk"></span> {{_('Save')}}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

% include('_footer.tpl')