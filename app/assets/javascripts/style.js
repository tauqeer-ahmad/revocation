$(document).on('ready', function() {
  $("input.datepicker").datepicker({
    dateFormat : "dd MM yy"
  });

  $( "#tabs" ).tabs({
    beforeLoad: function(event, ui) {
      ui.panel.html('<div class="tab-loader"><img src="/assets/loading.gif" width="24" height="24" style="vertical-align:middle;"> Loading...</div>');
    }
  }).addClass( "ui-tabs-vertical ui-helper-clearfix" );
  $( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
}) 
