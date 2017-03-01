// override jquery validate plugin defaults
$.validator.setDefaults({
    highlight: function(element) {
        $(element).closest('div').addClass('has-error');
    },
    unhighlight: function(element) {
        $(element).closest('div').removeClass('has-error');
    },
    errorElement: 'span',
    errorClass: 'help-block',
    errorPlacement: function(error, element) {
        if(element.parent('.input-group').length) {
            error.insertAfter(element.parent());
        } else {
            error.insertAfter(element);
        }
    }
});

// Replaces {key} expressions in a string with prm[key] values
var templateString = function(tstr, prm) {
    tstr = tstr.replace(/{[^{}]+}/g, function(key){
        return prm[key.replace(/[{}]+/g, '')] || "";
    });
    return tstr;
};

var make_datepicker = function (elements) {
    $(elements).datepicker({
        format: "dd.mm.yyyy",
        calendarWeeks: true,
        autoclose: true,
        todayHighlight: true,
        weekStart: 1,
        orientation: "top auto"
    });
};

$(document).ready(function(){
    make_datepicker(".date");


    /**
     * NAME: Bootstrap 3 Triple Nested Sub-Menus
     * This script will active Triple level multi drop-down menus in Bootstrap 3.*
     */
    $('ul.dropdown-menu [data-toggle=dropdown]').on('click', function(event) {
        // Avoid following the href location when clicking
        event.preventDefault();
        // Avoid having the menu to close when clicking
        event.stopPropagation();
        // Re-add .open to parent sub-menu item
        $(this).parent().addClass('open');
        $(this).parent().find("ul").parent().find("li.dropdown").addClass('open');
    });


    //Main screen combobox select
    $("#main_project_select").change(function () {
        var str = $("#main_project_select option:selected").text();
        window.location = '/project/' + str;
        return false;
    });


    function postTakvim(event, delta) {
        var dt_stx = event.start.format('DD.MM.YYYY');
        var tm_stx = event.start.format('hh:mm');
        if (event.end) {
            var dt_fnx = event.end.format('DD.MM.YYYY');
            var tm_fnx = event.end.format('hh:mm');
        } else {
            var dt_fnx = '';
            var tm_fnx = '';
        }

        $.ajax({
            type: "POST",
            url: '/issue_popup',
            data: {
                'issue_id': event.id,
                'act': 'dt_plan',
                'val': dt_stx,
                'val_fn': dt_fnx
            },
            success: function(data, textStatus, jqXHR) {
                if (data.success == 1) {
                    //do nothing
                } else {
                    alert(data.message);
                }
            },
            dataType: 'json'
        });

        event.ischanging = false;

    };

    //Generate Calendar
    $('#calendar').fullCalendar({
        weekNumbers: true,
        lang: 'tr',
        aspectRatio: 3,
        editable: true,

        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay '
        },
        eventSources: [
            {//etkinlikler
                url: '/get_cal_events',
                type: 'POST',
                data: {
                    project_id: $("#cal-project_id").val(),
                    usr_id: $("#cal-usr_id").val(),
                    client_id: $('#cal-client_id').val()
                },
                error: function() {
                    //alert('there was an error while fetching events!');
                }
                //color: 'light',   // a non-ajax option
                //textColor: 'black' // a non-ajax option
            }],

        eventRender: function(event, element) {
            if (!event.ischanging) {
                element.popover({
                    html: true,
                    trigger: 'hover',
                    content: event.description,
                    placement: 'bottom',
                    container: 'body'
                });
            }

            element.find('.fc-title').html(event.title);

        },
        eventClick: function(event) {
            if (event.url) {
                window.open(event.url);
                return false;
            }
        },
        eventDrop: function(event, delta, revertFunc) {
            postTakvim(event)
        },
        eventResize: function(event, delta, revertFunc) {
            postTakvim(event)
        },
        eventDragStart: function( event, jsEvent, ui, view ) {
            event.ischanging = true
        },
        eventResizeStart: function( event, jsEvent, ui, view ) {
            event.ischanging = true
        }


    })


});
