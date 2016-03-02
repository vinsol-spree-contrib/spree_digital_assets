$(document).ready(function() {
  var ready = true;

  var load_more_objects = function(folder_assets) {
    var $folder_assets = folder_assets || $('#folder_assets'),
      url = $folder_assets.attr('data-next-url');

    if(ready && url && $folder_assets.length) {
      ready = false;
      $.ajax({
        url: url,
        method: 'GET',
        dataType: 'script',
        complete: function(){
          ready = true;
        }
      });
    }
  }

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
