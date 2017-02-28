% include('_header.tpl')

<div class="row">
    <div class="col-sm-12">
        <ul class="nav nav-tabs">
            <li class="active"><a href="#general" data-toggle="tab">{{_('General')}}</a></li>
            <li><a href="#display" data-toggle="tab">{{_('Display')}}</a></li>
            <li><a href="#auth" data-toggle="tab">{{_('Authentication')}}</a></li>
            <li><a href="#db-config" data-toggle="tab">{{_('Database Config')}}</a></li>
            <li><a href="#mail" data-toggle="tab">{{_('EMail')}}</a></li>
        </ul>

        <form class="form-horizontal" role="form" style="margin-top: 10px;" method="POST">
            <div class="tab-content">
                <div class="tab-pane active" id="general">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Site URL')}}</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="site_url" placeholder="Site URL"
                                   value="{{cnf['general']['site_url']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Site Brand')}}</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="site_brand" placeholder="Site Brand"
                                   value="{{cnf['general']['site_brand']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Site Title')}}</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="site_title" placeholder="Site Title"
                                   value="{{cnf['general']['site_title']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Welcome Text')}}</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" rows="4" name="welcome_text">{{cnf['general']['welcome_text']}}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Footer Text')}}</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="footer_text" placeholder="Footer Text"
                                   value="{{cnf['general']['footer_text']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Template')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="template" placeholder="Template"
                                   value="{{cnf['general']['template']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Store Files In Db')}}</label>
                        <div class="col-sm-2">
                            <input type="checkbox" name="store_files_in_db" value="1"
                            {{"checked" if cnf['general']['store_files_in_db'] else ""}}
                            />
                        </div>
                        <label class="col-sm-2 control-label">{{_('Thumb Size')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="thumb_size" placeholder="Thumbnail image size"
                                   value="{{cnf['general']['thumb_size']}}">
                        </div>
                        <label class="col-sm-2 control-label">{{_('Image Size')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="image_size" placeholder="Image size"
                                   value="{{cnf['general']['image_size']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Test Run')}}</label>
                        <div class="col-sm-2">
                            <input type="checkbox" name="test_run" value="1"
                            {{"checked" if cnf['general']['test_run'] else ""}}
                            />
                        </div>
                        <label class="col-sm-2 control-label">{{_('Debugging On')}}</label>
                        <div class="col-sm-2">
                            <input type="checkbox" name="debugging_on" value="1"
                            {{"checked" if cnf['general']['debugging_on'] else ""}}
                            />
                        </div>
                    </div>
                </div>

                <div class="tab-pane" id="display">
                    <p>test</p>
                </div>

                <div class="tab-pane" id="auth">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Login Required')}}</label>
                        <div class="col-sm-2">
                            <input type="checkbox" name="login_required" value="1"
                            {{"checked" if cnf['auth']['login_required'] else ""}}
                            />
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Self Registration')}}</label>
                        <div class="col-sm-2">
                            <select class="form-control" name="self_registration">
                                <option value="0" {{"checked" if cnf['auth']['self_registration'] == 0 else ""}}>
                                {{_('By Admin')}}</option>
                                <option value="1" {{"checked" if cnf['auth']['self_registration'] == 1 else ""}}>
                                {{_('Email Confirmation')}}</option>
                                <option value="2" {{"checked" if cnf['auth']['self_registration'] == 2 else ""}}>
                                {{_('Admin Confirmation')}}</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Active Directory Server')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="active_directory_server" placeholder="Active Directory Server"
                                   value="{{cnf['auth']['active_directory_server']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Session Timeout')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="session_timeout" placeholder="Cookie session timeout in seconds"
                                   value="{{cnf['auth']['session_timeout']}}">
                        </div>
                    </div>

                </div>

                <div class="tab-pane" id="db-config">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('RDBMS')}}</label>
                        <div class="col-sm-1">
                            <label>
                                <input type="radio" name="db_type" value="firebird"
                                        {{"checked" if cnf['database']['db_type'] == 'firebird' else ""}}
                                />
                                Firebird
                            </label>
                        </div>
                        <div class="col-sm-1">
                            <label>
                                <input type="radio" name="db_type" value="postgres"
                                    {{"checked" if cnf['database']['db_type'] == 'postgres' else ""}}
                                />
                                Postgres
                            </label>
                        </div>
                        <div class="col-sm-1">
                            <label>
                                <input type="radio" name="db_type" value="mysql"
                                    {{"checked" if cnf['database']['db_type'] == 'mysql' else ""}}
                                />
                                MySql
                            </label>
                        </div>
                        <div class="col-sm-1">
                            <label>
                                <input type="radio" name="db_type" value="mssql"
                                    {{"checked" if cnf['database']['db_type'] == 'mssql' else ""}}
                                />
                                MsSql
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Database Server')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="db_server"
                                   value="{{cnf['database']['db_server']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Database Path')}}</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="db_path"
                                   value="{{cnf['database']['db_path']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Database User')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="db_user"
                                   value="{{cnf['database']['db_user']}}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Database Password')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="db_pass"
                                   value="{{cnf['database']['db_pass']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Echo SqlAlchemy')}}</label>
                        <div class="col-sm-2">
                            <input type="checkbox" name="echo_sqlalchemy" value="1"
                            {{"checked" if cnf['database']['echo_sqlalchemy'] else ""}}
                            />
                        </div>
                    </div>

                </div>

                <div class="tab-pane" id="mail">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Email Server')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="m_server"
                                   value="{{cnf['mail']['server']}}">
                        </div>
                        <label class="col-sm-2 control-label">{{_('Port')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="m_port"
                                   value="{{cnf['mail']['port']}}">
                        </div>
                        <div class="col-sm-2">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" name="m_start_tls" value="1"
                                    {{"checked" if cnf['mail']['start_tls'] else ""}}
                                    />
                                    Start TLS
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Email Address')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="m_address"
                                   value="{{cnf['mail']['address']}}">
                        </div>
                        <label class="col-sm-2 control-label">{{_('From')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="m_from"
                                   value="{{cnf['mail']['from']}}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Login')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="m_login"
                                   value="{{cnf['mail']['login']}}">
                        </div>
                        <label class="col-sm-2 control-label">{{_('Password')}}</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" name="m_password"
                                   value="{{cnf['mail']['password']}}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Issue Mail Template')}}</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" rows="10" name="issue_mail">{{issue_mail}}</textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">{{_('Register Mail Template')}}</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" rows="10" name="register_mail">{{register_mail}}</textarea>
                        </div>
                    </div>

            </div>
            <div class="form-group">
                <div class="col-sm-10">
                    <button type="submit" class="btn btn-primary">Apply</button>
                </div>
            </div>

        </form>

    </div>
</div>


% include('_footer.tpl')