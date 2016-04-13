function show_loader(selector){
  var $loader = $('<div>').addClass('loader').html('<div class="spinner folder-assets-loader"></div><div class="section-overlay"></div>');
  $(selector).append($loader);
}

function hide_loader(){
  $('.loader').remove();
}

$(document).ready(function() {
  $('.tree-menu-container').on('click', '.toggle_list_menu', function() {
    $(this).toggleClass('glyphicon-chevron-right glyphicon-chevron-down');
    $(this).siblings('.tree-menu').slideToggle();
  });

  $("body").on('click', '#main-sidebar #folder_list a[data-remote=true]', function(){
    history.pushState('', '', $(this).attr('href'));
  });

  $('#main-sidebar #folder_list a[data-remote=true]').on('ajax:beforeSend', function(){
    $("#progress").stop(true, true).fadeIn();
  });

  $('#main-sidebar #folder_list a[data-remote=true]').on('ajax:complete', function(){
    $("#progress").fadeOut();
  });

  $('#upload_asset_modal_body #folder_list a[data-remote=true]').on('ajax:beforeSend', function(){
    show_loader('#folder_assets');
  });

  $('#upload_asset_modal_body #folder_list a[data-remote=true]').on('ajax:complete', function(){
    hide_loader();
  });
});
