// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  var $description = $('.curator_description textarea');
  var $hint = $description.parent().find('.text-info');

  $hint.addClass('clearfix');

  var $count = $('<span class="pull-xs-right text-muted"></span>');

  $count.appendTo($hint);

  function notBlank(string) {
    return !/^\s*$/.test(string);
  }

  $description.on('change input', function() {
    var words = $description.val().trim().split(/\s+/).filter(notBlank).length;
    var noun = words === 1 ? 'word' : 'words';

    $count.text('' + words + ' ' + noun);

    $count.removeClass('text-muted text-success text-danger');
    if (words < 10 || words > 70) {
      $count.addClass('text-danger');
    } else if (words >= 20 && words <= 50) {
      $count.addClass('text-success');
    } else {
      $count.addClass('text-muted');
    }
  }).trigger('change');
});
