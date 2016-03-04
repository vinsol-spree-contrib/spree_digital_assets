var digital_asset_load_ready = true;
$(document).ready(function() {

  $('#folder_assets').scroll(function(){
    var $folder_assets = $('#folder_assets');
    if($folder_assets.scrollTop() + $folder_assets.innerHeight() == $folder_assets[0].scrollHeight){
      load_more_objects($folder_assets);
    }
  });

  $(window).scroll(function() {
    if($(window).scrollTop() + window.innerHeight == document.body.offsetHeight){
      load_more_objects();
    }
  });
});

function load_more_objects(folder_assets) {
  var $folder_assets = folder_assets || $('#folder_assets'),
    url = $folder_assets.attr('data-next-url');

  if(digital_asset_load_ready && url && $folder_assets.length) {
    send_ajax_load_assets(url);
  }
}

function send_ajax_load_assets(url){
  digital_asset_load_ready = false;
  $.ajax({
    url: url,
    method: 'GET',
    dataType: 'script',
    complete: function(){
      digital_asset_load_ready = true;
    }
  });
}
