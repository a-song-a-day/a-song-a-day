$(function() {
  var $form = $('#signup_curators_form');
  var $button = $form.find('button');

  function disableSubmit() {
    $button.prop('disabled', $form.find('input:checked').length === 0);
  }

  $form.find('input').change(disableSubmit);

  disableSubmit();
});
