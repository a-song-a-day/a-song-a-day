// Word count for form fields. To use, add the "data-word-count" attribute
// to the wrapper class, specifying maximum and minimum. For example:
//
// <%= f.input :description, input_html: { rows: 4 },
//   wrapper_html: { data: { word_count: "20:50" } },
//   hint: "Aim for around 20–50 words." %>

$(function() {
  var FUDGE = 10;

  $('[data-word-count]').each(function() {
    var $wrapper = $(this);
    var range = $wrapper.data('word-count').split(':');
    var $description = $wrapper.find('textarea');
    var $hint = $wrapper.find('.text-muted');

    var minimum = parseInt(range[0], 10) || 0;
    var maximum = parseInt(range[1], 10) || Infinity

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
      if (words < minimum - FUDGE || words > maximum + FUDGE) {
        $count.addClass('text-danger');
      } else if (words >= minimum && words <= maximum) {
        $count.addClass('text-success');
      } else {
        $count.addClass('text-muted');
      }
    }).trigger('change');
  });
});
