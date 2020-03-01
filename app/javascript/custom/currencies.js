function bind_refresh() {
  $(".refresh-icon").on( "click", function() {
    $(".refresh-icon").addClass('rotating');
  });
}

$(document).ready(function() {
  bind_refresh();
});