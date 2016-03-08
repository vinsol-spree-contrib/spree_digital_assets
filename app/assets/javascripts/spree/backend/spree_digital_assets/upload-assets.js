var UploadAssets = function () {}

UploadAssets.prototype.uploaderTabs = function () {
  var $tabLinks = $('.upload-assets-tabs-block .upload-assets-tabs-link');

  $tabLinks.on('click', function () {
    var $this = $(this),
        $dataVal = $this.data('tab'),
        $tabContent = $('#' + $dataVal);

    $this.addClass('current').parent('.upload-assets-tabs-holder').siblings('.upload-assets-tabs-holder').find('.upload-assets-tabs-link').removeClass('current');

    $('.upload-assets-tab-content .upload-assets-tab-block').hide();

    $tabContent.show();
  });
}

$(function () {
  var uploadAssets = new UploadAssets();
  uploadAssets.uploaderTabs();
});