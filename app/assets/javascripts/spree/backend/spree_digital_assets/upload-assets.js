var UploadAssets = function (toggleLink, hideLink) {
  this.toggleLink = toggleLink;
  this.hideLink = hideLink;
}

UploadAssets.prototype.init = function () {
  this.toggleUploaderBlock();
  this.hideUploaderBlock();
}

UploadAssets.prototype.toggleUploaderBlock = function () {
  this.toggleLink.on('click', function () {
    var $this = $(this);
    $this.toggleClass('condensed').parents('.upload-assets-section').find('.upload-assets-content').slideToggle();
  });
}

UploadAssets.prototype.hideUploaderBlock = function () {
  this.hideLink.on('click', function () {
    $(this).parents('.upload-assets-section').addClass('hidden');
  });
}

$(function () {
  var uploadAssets = new UploadAssets($('.upload-assets-header-actions-link.minimize-link'), $('.upload-assets-header-actions-link.close-link'));
  uploadAssets.init();
});
