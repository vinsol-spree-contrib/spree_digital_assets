$(document).ready(function(){
  initialize_jquery_fileupload();
});

//Helper function for calculation of progress
function formatFileSize(bytes) {
  if (typeof bytes !== 'number') {
    return '';
  }

  if (bytes >= 1000000000) {
    return (bytes / 1000000000).toFixed(2) + ' GB';
  }

  if (bytes >= 1000000) {
    return (bytes / 1000000).toFixed(2) + ' MB';
  }
  return (bytes / 1000).toFixed(2) + ' KB';
}

function initialize_jquery_fileupload(){
  var ul = $('#fileList');

  $('#new_multiple_digital_asset_form').fileupload({

    // This function is called when a file is added to the queue
    add: function (e, data) {
      var tpl = $('<div class="working upload">' +
                  '<div class="progress">' +
                  '<div class="progress-bar bar"></div ></div>' +
                  '<div class="percent">0%</div >' +
                  '<div class="file_name"></div><a href="javascript:">Cancel</a>' +
                  '</div>');

      // Append the file name and file size
      tpl.find('div.file_name').text(data.files[0].name)
                   .append('<i>' + formatFileSize(data.files[0].size) + '</i>');

      // Add the HTML to the UL element
      data.context = tpl.appendTo(ul);

      // Initialize the knob plugin. This part can be ignored, if you are showing progress in some other way.

      // Automatically upload the file once it is added to the queue
      var jqXHR = data.submit();

      // Listen for clicks on the cancel icon
      tpl.find('a').click(function(){
        if(tpl.hasClass('working')){
          jqXHR.abort();
        }
        tpl.fadeOut(function(){
          tpl.remove();
        });
      });
    },
    progress: function(e, data){

      // Calculate the completion percentage of the upload
      var progress = parseInt(data.loaded / data.total * 100, 10);

      var percentVal = progress + '%';
      data.context.find('.bar').width(percentVal);
      data.context.find('.percent').html(percentVal);

      if(progress == 100){
        data.context.removeClass('working');
        data.context.find('a').remove();
      }
    },
    done: function(e, data){
      data.context.find('.percent').html('Successfully uploaded');
    },
    fail: function(e, data){
      data.context.find('.percent').html('Error: ' + data.jqXHR.responseJSON.errors);
    }
  });
}
