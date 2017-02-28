% show_navbar = False
% include('_header.tpl')


<div class="row" style="margin-top: 50px;">
    <div class="col-sm-offset-4 col-sm-4">
        <form role="form" method="post">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">{{config['general.site_brand']}} {{_('Login')}}</h3>
                </div>
                <div class="panel-body">


                    <div class="form-group">
                        <label>{{_('Username')}}</label>
                        <input type="text" class="form-control" name="code" value="{{usr_code}}" placeholder="{{_('Username')}}">
                    </div>

                    <div class="form-group">
                        <label>{{_('Password')}}</label>
                        <input type="password" class="form-control" name="upass" placeholder="{{_('Password')}}">
                    </div>

                    %if error:
                    <div class="alert alert-danger alert-dismissable">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        {{_('Username or password was incorrect.')}}
                    </div>
                    %end

                </div>
                <div class="panel-footer">
                    <button class="btn btn-primary" type="submit">{{_('Login')}}</button>
                    &nbsp; &nbsp;
                    <a href="/lostpassword">{{_('Forgot your password?')}}</a>
                    <!--<button class="btn">{{_('Lost Password')}}</button>-->
                    %if self_registration == '1':
                    <p>
                        <br/>
                        <a href="/register">
                            {{_('Create an Account')}}
                        </a>
                    </p>
                    %end

                </div>
            </div>
        </form>
    </div>
</div>

% include('_footer.tpl')