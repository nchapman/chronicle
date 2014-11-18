$(document).on('ready page:load', function () {

  function updateActionState(anchor) {
    var $anchor = $(anchor);
    var label;

    if ($anchor.is('.active')) {
      label = $anchor.attr('data-label');
    } else {
      label = $anchor.attr('data-active-label');
    }

    $anchor.find('.label').html(label);
    $anchor.toggleClass('active');
  }

  function updateUserPage(id, attrs) {
    $.ajax({
      url: '/user_pages/' + id + '.json',
      type: 'PUT',
      data: {
        user_page: attrs
      }
    });
  }

  // Handle like action
  $('.actions a.like').click(function (event) {
    event.preventDefault();

    var $like = $(this);

    updateActionState($like);
    updateUserPage($like.attr('data-id'), { liked: $like.is('.active') });
  });

  // Handle save action
  $('.actions a.save').click(function (event) {
    event.preventDefault();

    var $save = $(this);

    updateActionState($save);
    updateUserPage($save.attr('data-id'), { saved: $save.is('.active') });
  });

  // Handle archive action
  $('.actions a.archive').click(function (event) {
    event.preventDefault();

    var $archive = $(this);

    updateActionState($archive);
    updateUserPage($archive.attr('data-id'), { archived: $archive.is('.active') });

    if ($archive.is('.active')) {
      $archive.closest('.page').fadeOut('slow', function () {
        $(this).remove();
      });
    }
  });
});
