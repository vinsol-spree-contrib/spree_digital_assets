(function() {
  jQuery(function() {
    $('#new_multiple_digital_asset_form').attr('name', 'digital_asset[attachment]');
    return $('#new_multiple_digital_asset_form').fileupload({
      dataType: 'script',
      add: function(e, data) {
        var file;
        file = data.files[0];
        data.context = $(tmpl("template-upload", file));
        $('#new_multiple_digital_asset_form').append(data.context);
        return $('.actions input[type="submit"]').click(function(e) {
          data.submit();
          return e.preventDefault();
        });
      },
      progress: function(e, data) {
        var progress;
        if (data.context) {
          progress = parseInt(data.loaded / data.total * 100, 10);
          return data.context.find('.bar').css('width', progress + '%');
        }
      },
      done: function(e, data) {
        return $('.actions input[type="submit"]').off('click');
      }
    });
  });

}).call(this);
