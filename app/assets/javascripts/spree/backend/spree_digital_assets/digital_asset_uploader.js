GB_BYTES_COUNT = 1000000000;
MB_BYTES_COUNT = 1000000;
KB_BYTES_COUNT = 1000;

var DigitalAssetUploader = function(upload_assets_section, new_multiple_digital_asset_form){
  this.upload_assets_section = upload_assets_section;
  this.upload_assets_content = this.upload_assets_section.find('.upload-assets-content');
  this.new_multiple_digital_asset_form = new_multiple_digital_asset_form;
}

DigitalAssetUploader.prototype.initializeAssetUploader = function(){
  var _this = this;
  this.new_multiple_digital_asset_form.fileupload({
    add: function (e, data) {
      var upload_assets_row = $('.upload_assets_row.hidden .upload-assets-content-row').clone();
      upload_assets_row.find('div.file_name').text(data.files[0].name)
        .append('<i>' + _this.formatFileSize(data.files[0].size) + '</i>');

      data.context = upload_assets_row.prependTo(_this.upload_assets_content);
      _this.showAndInitializeUploadAssetSection();
      var jqXHR = data.submit();
      _this.bindCancelLinkEvent(upload_assets_row, jqXHR);
    },
    progress: function(e, data){

      // Calculate the completion percentage of the upload
      var progress = _this.calculateProgress(data);

      var percentVal = progress + '%';
      data.context.find('.bar').width(percentVal);
      data.context.find('.percent').html(percentVal);

      if(progress == 100){
        data.context.removeClass('working');
        data.context.find('a.cancel').remove();
      }
    },
    done: function(e, data){
      data.context.addClass('success').removeClass('uploading');
      data.context.find('.upload-assets-uploader-status strong.status').addClass('success').html('Successfully uploaded');
    },
    fail: function(e, data){
      data.context.addClass('fail').removeClass('uploading');
      data.context.find('.upload-assets-uploader-status strong.status').addClass('fail').html('Error: ' + data.jqXHR.responseJSON.errors);
    },
    stop: function(e, data){
      _this.setSuccessFailHeader();
    }
  });
}

DigitalAssetUploader.prototype.formatFileSize = function(bytes){
  if (typeof bytes !== 'number') {
    return '';
  }

  if (bytes >= GB_BYTES_COUNT) {
    return (bytes / GB_BYTES_COUNT).toFixed(2) + ' GB';
  }

  if (bytes >= MB_BYTES_COUNT) {
    return (bytes / MB_BYTES_COUNT).toFixed(2) + ' MB';
  }
  return (bytes / KB_BYTES_COUNT).toFixed(2) + ' KB';
}

DigitalAssetUploader.prototype.showAndInitializeUploadAssetSection = function(){
  this.upload_assets_section.removeClass('hidden');
  this.upload_assets_section.find('.upload-assets-content').show();
  this.upload_assets_section.find('.header_title').html('Uploading ' + this.upload_assets_content.find('.upload-assets-content-row.working:visible').length + ' files');
  this.upload_assets_section.find('.upload-assets-content-row.single_request:visible:not(.uploading)').removeClass('single_request');
}

DigitalAssetUploader.prototype.bindCancelLinkEvent = function(upload_assets_row, jqXHR){
  upload_assets_row.find('a.cancel').click(function(){
    if(upload_assets_row.hasClass('working')){
      jqXHR.abort();
    }
    upload_assets_row.fadeOut(function(){
      upload_assets_row.remove();
    });
  });
}

DigitalAssetUploader.prototype.setSuccessFailHeader = function(){
  var success_count = this.upload_assets_section.find('.upload-assets-content-row.single_request.success:visible').length,
    failure_count = this.upload_assets_section.find('.upload-assets-content-row.single_request.fail:visible').length,
    title = success_count + ' Assets Uploaded Successfully';
  if(failure_count){
    title += ' and ' + failure_count + ' Failed';
  }
  this.upload_assets_section.find('.header_title').html(title);
}

DigitalAssetUploader.prototype.calculateProgress = function(data){
  return parseInt(data.loaded / data.total * 100, 10);
}

$(document).ready(function(){
  initializeDigitalAssetUploader();
});

function initializeDigitalAssetUploader(){
  var digital_asset_uploader = new DigitalAssetUploader($('.upload-assets-section'), $('#new_multiple_digital_asset_form'));
  digital_asset_uploader.initializeAssetUploader();
}
