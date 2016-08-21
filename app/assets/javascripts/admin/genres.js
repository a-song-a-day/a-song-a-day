$(function() {
  var $genre = $('#curator_genre_id');

  if ($genre.length === 0) {
    return;
  }

  var previousValue = $genre.val();
  var $checkboxes = $genre.closest('form').find('input[type=checkbox]');

  $genre.change(function() {
    var newValue = $genre.val();

    $checkboxes.filter('[value=' + previousValue + ']').prop('checked', false);
    $checkboxes.filter('[value=' + newValue + ']').prop('checked', true);

    previousValue = newValue;
  });
})
