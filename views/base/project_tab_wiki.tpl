% include('_header.tpl')

% include('_project_tab_header.tpl')

<div class="row" style="margin-top: 5px;">
    <div class="col-xs-2">
        <div class="panel panel-primary">
            <div class="panel-heading">
                {{_('Wiki Pages')}}
            </div>
            <ul class="list-group">
                <!-- todo : https://github.com/jonmiles/bootstrap-treeview -->
                %for awiki in wikis:
                    <li class="list-group-item">
                        <a href="/wiki/{{arec.code}}/{{awiki.link}}">{{awiki.title}}</a>
                    </li>
                %end
            </ul>
        </div>
    </div>

    <div class="col-xs-10">
        <div id="div-editor" class="form-horizontal" style="display: none;">
            <div class="form-group">
                <label for="title" class="control-label col-sm-1">{{_('Title')}}</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="title" name="title" value="{{wiki.title}}">
                </div>
            </div>

            <div class="form-group">
                <label for="link" class="control-label col-sm-1">{{_('Wiki Link')}}</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="link" name="link" value="{{wiki.link}}">
                </div>
            </div>

            <div class="form-group">
                <label for="parent_id" class="control-label col-sm-1">{{_('Parent Page')}}</label>
                <div class="col-sm-8">
                    <select class="form-control" id="parent_id" name="parent_id" >
                        <option value="">--</option>
                        %for awiki in wikis:
                        <option value="{{awiki.id}}" {{"selected" if awiki.id == wiki.parent_id else ""}}>{{awiki.link}}</option>
                        %end
                    </select>
                </div>
            </div>

            <input type="hidden" class="form-control" id="id" name="id" value="{{wiki.id}}">
            <input type="hidden" class="form-control" id="project_id" name="project_id" value="{{wiki.project_id}}">

            <textarea id="wiki-editor" style="margin-top: 50px;">{{wiki.text}}</textarea>
        </div>

        <div class="panel panel-success" id="div-text">
            <div class="panel-heading">
                <span id="wiki-title">{{wiki.title}}</span>
                <div class="btn-group btn-group-xs pull-right">
                    <a href="#" class="text-success" id="btn-add" title="{{_('New page')}}"><span class="glyphicon glyphicon-plus"></span></a>
                    <a href="#" style="margin-left: 5px;" id="btn-edit" title="{{_('Edit page')}}"><span class="glyphicon glyphicon-pencil"></span></a>
                    <a href="#" class="text-red" style="margin-left: 5px;" id="btn-del" title="{{_('Delete page')}}"><span class="glyphicon glyphicon-trash"></span></a>
                </div>
            </div>
            <div class="panel-body" id="wiki-content" data-wiki="{{wiki.text}}">
            </div>
        </div>

    </div>
</div>

% include('_project_tab_footer.tpl')

% include('_footer.tpl')


<script>
    var slugify = false;

    var slug = function(str) {
        //Source : http://stackoverflow.com/questions/1053902/how-to-convert-a-title-to-a-url-slug-in-jquery

        str = str.replace(/^\s+|\s+$/g, ''); // trim
        str = str.toLowerCase();

        // remove accents, swap � for n, etc
        var from = "ãàáäâẽèéëêìíïîõòóöôùúüûñçgusio·/_,:;";
        var to   = "aaaaaeeeeeiiiiooooouuuuncgusio------";
        for (var i=0, l=from.length ; i<l ; i++) {
            //todo: buradaki try catch win makinede ? karakterinde sistem hata verdi�i i�in konuldu
            try {
                str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
            } catch(err) {

            }

        }

        str = str.replace(/[^a-z0-9 -]/g, '') // remove invalid chars
                .replace(/\s+/g, '-') // collapse whitespace and replace by -
                .replace(/-+/g, '-'); // collapse dashes

        return str;
    };

    var render_wiki = function(wiki_text) {
        var parser = simplemde.constructor.markdown;

        //Wiki Style Links
        wiki_text = wiki_text.replace(/\[\[[a-zA-Z-\d]+\]\]/g, function(key){
            var link = key.replace(/\[\[/g, '').replace(/\]\]/g, '');
            return '<a href="/wiki/{{arec.code}}/' + link + '">' + link + '</a>';
        });

        //Issue id's to links ie : #586 -> <a href="/issue/486>#486</a>
        wiki_text = wiki_text.replace(/#\d+/g, function(key){
            return '<a href="/issue/' + key.replace("#", "") + '">' + key + '</a>';
        });

        var rendered_html = parser(wiki_text);


        $("#wiki-content").html(rendered_html);
    };

    var editPage = function() {
        var wiki_text = $("#wiki-content").data("wiki");
        simplemde.value(wiki_text);

        slugify = false;
        $('#link').prop('readonly', true);

        $("#div-text").hide();
        $("#div-editor").show();
    };

    var addPage = function() {
        simplemde.value("");
        $("#title").val("");
        $("#link").val("");
        $("#id").val("");
        $("#project_id").val("{{arec.id}}");
        $("#parent_id").val("");

        slugify = true;
        $('#link').prop('readonly', false);

        $("#div-text").hide();
        $("#div-editor").show();
    };

    var delPage = function() {

    };

    var savePage = function() {
        var wiki_text = simplemde.value();

        var post_data = {
            id: $("#id").val(),
            title: $("#title").val(),
            link: $("#link").val(),
            text: wiki_text,
            project_id: $("#project_id").val(),
            parent_id: $("#parent_id").val()
        };


        $.ajax({
            method: "POST",
            url: '/wikiopr',
            data: post_data,
            dataType: "json",
            beforeSend: function() {
                //todo: processing modal
                //$('#processing-modal').modal('show');
            },
            error: function (e) {
                //
            }
        }).done(function(rslt, textStatus, jqXH){
            if (rslt.success) {
                render_wiki(wiki_text);
                $("#wiki-content").data("wiki", wiki_text);
                $("#wiki-title").text($("#title").val());

                $("#div-text").show();
                $("#div-editor").hide();

                $("#id").val(rslt.id)
            } else {
                alert(rslt.message);
            }
        }).fail(function(rslt){
            alert(rslt.responseText);
        }).always(function () {
            //todo: processing modal
            //$('#processing-modal').modal('hide');
        });

        return false;
    };

    var cancelEdit = function() {
        $("#title").val("{{wiki.title}}");
        $("#link").val("{{wiki.link}}");
        $("#id").val("{{wiki.id}}");
        $("#project_id").val("{{arec.id}}");
        $("#parent_id").val("{{wiki.parent_id}}");


        $("#div-text").show();
        $("#div-editor").hide();
    };

    var simplemde = new SimpleMDE({
        element: document.getElementById("wiki-editor"),
        spellChecker: false,
        toolbar: ["bold", "italic", "strikethrough", "heading", "|",
            "code", "quote", "horizontal-rule", "|",
            "unordered-list", "ordered-list", "|",
            "link", "image", "|",
            //"side-by-side", "fullscreen", "|",
            "preview", "|",
            {
                name: "save",
                action: savePage,
                className: "fa fa-save",
                title: "{{_('Save Page')}}"
            },
            {
                name: "cancel",
                action: cancelEdit,
                className: "fa fa-times",
                title: "{{_('Cancel Editing')}}"
            }

        ]
    });
    var wiki_text = $("#wiki-content").data("wiki");
    simplemde.value(wiki_text);
    render_wiki(wiki_text);
    simplemde.render();

    $(document).ready(function() {
        $("#btn-edit").click(function() {
           editPage();
        });

        $("#btn-add").click(function() {
           addPage();
        });

        $("#btn-del").click(function() {
           delPage();
        });

        $("#title").change(function () {
            if (slugify) {
                var title = $("#title").val();
                if (title) {
                    var str = slug(title);
                    $("#link").val(str);
                }
            }

            return false;
        });

    }) ;
</script>