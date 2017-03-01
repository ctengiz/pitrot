<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>{{config['general.site_title']}}</title>

    <!-- Font -->
    <!--
    <link href='http://fonts.googleapis.com/css?family=PT+Sans:400,700,400italic&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    -->
    <!--
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,800,700,400italic,600italic,700italic,800italic,300italic" rel="stylesheet" type="text/css">
    -->

    <!-- Bootstrap core CSS -->
    <link href="/static/vendor/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Fontawesome -->
    <link href="/static/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet">

    <script src="/static/vendor/jquery/dist/jquery.min.js"></script>
    <script src="/static/vendor/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- JQuery UI -->
    <!--
    <script src="/static/vendor/jquery-ui-1.11.4.min.js"></script>
    -->

    <!-- Date Picker -->
    <link href="/static/vendor/bootstrap-datepicker/dist/css/bootstrap-datepicker3.min.css" rel="stylesheet">
    <script src="/static/vendor/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>

    <!-- Select2 -->
    <link href="/static/vendor/select2/dist/css/select2.min.css" rel="stylesheet">
    <script src="/static/vendor/select2/dist/js/select2.full.min.js"></script>

    <!-- Validation -->
    <script src="/static/vendor/jquery-validation/dist/jquery.validate.min.js"></script>

    <!-- summernote css/js-->
    <link rel="stylesheet" href="/static/vendor/summernote/dist/summernote.css" />
    <script type="text/javascript" src="/static/vendor/summernote/dist/summernote.min.js"></script>

    <!-- x-editable -->
    <link href="/static/vendor/x-editable/dist/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet"/>
    <script src="/static/vendor/x-editable/dist/bootstrap3-editable/js/bootstrap-editable.min.js"></script>

    <!-- Table Sorter -->
    <link rel="stylesheet" href="/static/vendor/tablesorter/dist/css/theme.bootstrap.min.css">
    <script type="text/javascript" src="/static/vendor/tablesorter/dist/js/jquery.tablesorter.min.js"></script>
    <script type="text/javascript" src="/static/vendor/tablesorter/dist/js/jquery.tablesorter.widgets.min.js"></script>
    <link rel="stylesheet" href="/static/vendor/tablesorter/dist/css/jquery.tablesorter.pager.min.css">
   	<script type="text/javascript" src="/static/vendor/tablesorter/dist/js/extras/jquery.tablesorter.pager.min.js"></script>

    <!-- jQuery Upload File -->
    <script type="text/javascript" src="/static/vendor/jquery-form/dist/jquery.form.min.js"></script>
    <link rel="stylesheet" href="/static/vendor/jquery-upload-file/css/uploadfile.css">
    <script type="text/javascript" src="/static/vendor/jquery-upload-file/js/jquery.uploadfile.js"></script>

    <!-- Moment -->
    <script type="text/javascript" src="/static/vendor/moment/min/moment.min.js"></script>

    <!-- Full Calendar -->
    <link rel="stylesheet" href="/static/vendor/fullcalendar/dist/fullcalendar.min.css">
    <script type="text/javascript" src="/static/vendor/fullcalendar/dist/fullcalendar.min.js"></script>
    <!--
    #todo: i18n support
    <script type="text/javascript" src="/static/vendor/fullcalendar/lang/tr.js"></script>
    -->

    <!-- Excellent Export -- https://github.com/jmaister/excellentexport -->
    <script type="text/javascript" src="/static/vendor/excellentexport/excellentexport.min.js"></script>

    <!-- Bootbox -->
    <script type="text/javascript" src="/static/vendor/bootbox.js/bootbox.js"></script>

    <!-- SimpleMDE -->
    <script src="/static/vendor/simplemde/dist/simplemde.min.js"></script>
    <link href="/static/vendor/simplemde/dist/simplemde.min.css" rel="stylesheet">

    <!-- Base Css & Js -->
    <!-- <link href="/static/pitrot.css?4" rel="stylesheet"> -->
    <script src="/static/pitrot.js"></script>
    <link href="/static/pitrot.css" rel="stylesheet">

</head>

<body>

<!-- Static navbar -->
<%
if not defined('show_navbar'):
    setdefault('show_navbar', True)
end
%>


% if show_navbar:
<nav class="navbar navbar-inverse navbar-fixed-top ">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">{{_('Toggle Navigation')}}</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/">{{config['general.site_brand']}}</a>
        </div>

        <div class="collapse navbar-collapse navbar-ex1-collapse">
            <ul class="nav navbar-nav">
                <li><a href="/">{{_('Home')}}</a></li>

                %if session['logged_in']:
                    <li><a href="/user/{{session['usr_id']}}">{{_('My Page')}}</a></li>
                %end

                % if session['is_admin']:
                <li><a href="/issue/list">{{_('All Issues')}}</a></li>
                <li><a href="/overview">{{_('Overview')}}</a></li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">{{_('Administration')}}<b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li><a href="/admin/project">{{_('Projects')}}</a></li>
                        <li><a href="/admin/client">{{_('Clients')}}</a></li>
                        <li><a href="/admin/user">{{_('Users')}}</a></li>
                        <li><a href="/admin/usrgrp">{{_('Groups')}}</a></li>
                        <li><a href="/admin/usrrole">{{_('Roles & Permissions')}}</a></li>
                        <li class="divider"></li>
                        <li><a href="/admin/dfissuecategory">{{_('Issue Categories')}}</a></li>
                        <li><a href="/admin/dfissuestatus">{{_('Issue Statuses')}}</a></li>
                        <li><a href="/admin/dfissuepriority">{{_('Issue Priorities')}}</a></li>
                        <li><a href="/workflow">{{_('Workflow')}}</a></li>
                        <li class="divider"></li>
                        <li><a href="/admin/settings">{{_('Settings')}}</a></li>
                    </ul>
                </li>
                % end
                <li><a href="#">Rev.No: {{revision}}</a></li>
            </ul>

            <ul class="nav navbar-nav navbar-right">
                <li>
                    <form action="#" class="navbar-form navbar-left">
                        <select class="form-control input-sm" id="main_project_select">
                            <option>{{_('--Projects--')}}</option>
                            %for k in list_usr_projects(db):
                            <option value="/project/{{k.code}}"
                                    {{'selected="selected"' if session['current_project'] == k.code else ''}}
                                    >{{k.code}}</option>
                            %end
                        </select>
                    </form>
                </li>
                <li>
                    <form action="#" class="navbar-form">
                        <div class="btn-group">
                            <button type="button" class="btn btn-default dropdown-toggle btn-sm" data-toggle="dropdown">
                                {{_('Actions')}} <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu" style="left: 0; right: auto;">
                                %if session['logged_in']:
                                <li><a href="/issue/add">
                                    <span class="glyphicon glyphicon-bullhorn"></span> {{_('New Issue')}}
                                </a></li>
                                <li><a type="button" href="/worklog/add">
                                    <span class="glyphicon glyphicon-time"></span> {{_('Worklog')}}
                                </a></li>
                                %end
                            </ul>
                        </div>
                    </form>
                </li>
                <li>
                    <form action="#" class="navbar-form navbar-left">
                        %if session['logged_in']:
                        <div class="btn-group">
                            <button type="button" class="btn btn-default dropdown-toggle btn-sm" data-toggle="dropdown">
                                <span class="glyphicon glyphicon-user"></span>
                                {{_('My Account')}} <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu" style="left: 0; right: auto;">
                                <li><a href="/myaccount">
                                    <span class="glyphicon glyphicon-user"></span> {{_('Account Preferences')}}
                                </a></li>
                                <li><a type="button" href="/myissues">
                                    <span class="glyphicon glyphicon-time"></span> {{_('My Issues')}}
                                </a></li>
                                <li><a type="button" href="/logout">
                                    <span class="glyphicon glyphicon-off"></span>{{_('Logout')}}
                                </a></li>
                            </ul>
                        </div>
                        %else:
                            <a type="button" href="/myaccount" class="btn btn-primary btn-sm">
                                <!-- <span class="glyphicon glyphicon-user"></span> -->
                                {{_('Login / Sign Up')}}
                            </a>
                        %end
                    </form>
                </li>
                <li>
                    <!-- todo: arama fonksiyonu -->
                    <form class="navbar-form navbar-right" role="search">
                        <div class="input-group">
                            <input type="text" class="form-control input-sm" placeholder="{{_('Search')}}" name="q">
                            <div class="input-group-btn">
                                <button class="btn btn-default btn-sm" type="submit"><i class="glyphicon glyphicon-search"></i></button>
                            </div>
                        </div>
                    </form>
                </li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>
% end

% if defined('jumbotron'):
<div class="jumbotron">
    <div class="container-fluid">
        {{!jumbotron}}
        <h1>A Hedaer</h1>
        <p>
            Prensiben div ksımının altına html jumbotron kodunu koymamız lazım !
            This is a template for a simple marketing or informational website. It includes a large callout called a
            jumbotron and three supporting pieces of content. Use it as a starting point to create something more unique.
        </p>
        <p><a class="btn btn-primary btn-lg" role="button">Learn more &raquo;</a></p>
    </div>
</div>
% end

<div class="container-fluid">

    % if defined('breadcumb'):
    <ol class="breadcrumb">
        <li><a href="/">{{_('Home')}}</a></li>
        %for x in breadcumb[:-1]:
        <li><a href="{{!x.get('link')}}">{{x.get('defi')}}</a></li>
        % end
        <li class="active">{{breadcumb[-1].get('defi')}}</a></li>
    </ol>
    % end
