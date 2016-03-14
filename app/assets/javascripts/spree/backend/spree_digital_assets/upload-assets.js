var UploadAssets = function () {}

UploadAssets.prototype.init = function () {
  this.toggleUploaderBlock();
  this.hideUploaderBlock();
}

UploadAssets.prototype.toggleUploaderBlock = function () {
  var $toggleLink = $('.upload-assets-header-actions-link.minimize-link');

  $toggleLink.on('click', function () {
    var $this = $(this);

    $this.toggleClass('condensed').parents('.upload-assets-section').find('.upload-assets-content').slideToggle();
  });
}

UploadAssets.prototype.hideUploaderBlock = function () {
  $hideLink = $('.upload-assets-header-actions-link.close-link');

  $hideLink.on('click', function () {
    $(this).parents('.upload-assets-section').addClass('hidden');
  });
}

$(function () {
  var uploadAssets = new UploadAssets();
  uploadAssets.init();
});