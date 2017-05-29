$(document).on('ready', function() {
  $('input.timepicker').datetimepicker({
    format: 'LT'
  });

  $('input.datepicker').datetimepicker({
    format: 'DD/MM/YYYY',
    showTodayButton: true,
    sideBySide: true,
    widgetPositioning: {
        horizontal: 'left',
        vertical: 'bottom'
    }
  });

  $('input.datetimepicker').datetimepicker({
    format: 'DD/MM/YYYY LT',
    widgetPositioning: {
        horizontal: 'left',
        vertical: 'bottom'
    }
  });

  $( "#tabs" ).tabs({
    beforeLoad: function(event, ui) {
      ui.panel.html('<div class="tab-loader"><img src="/assets/loading.gif" width="24" height="24" style="vertical-align:middle;"> Loading...</div>');
    }
  }).addClass( "ui-tabs-vertical ui-helper-clearfix" );
  $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
})
