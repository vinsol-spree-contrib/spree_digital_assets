var $assetDetails;

function AssetDetails(selectors) {
  this.wrapper = selectors.wrapper;
};

AssetDetails.prototype.init = function() {
  var _this = this;
  this.wrapper.on('click', 'div.asset-area', function(){
    var $assetDetailsArea = _this.wrapper.find('.asset-details');
    _this.setAttributes($assetDetailsArea, $(this).find('img'));
    $assetDetailsArea.removeClass('hide');
  });
};

AssetDetails.prototype.showFileGlyphicon = function(img) {
  img.onerror = null;
  $(img).toggleClass('hide').siblings('.file-icon').toggleClass('hide');
};

AssetDetails.prototype.setAttributes = function($assetDetailsArea, $img) {
  $assetDetailsArea.find('#asset-name').html($img.data('name'));
  $assetDetailsArea.find('#file-size').html($img.data('size'));
  $assetDetailsArea.find('#created-date').html($img.data('created-on'));
  $assetDetailsArea.find('#modified-date').html($img.data('modified-on'));
  $assetDetailsArea.find('#related-products').html(this.setRelatedProducts($assetDetailsArea, $img.data('related-products')));
};

AssetDetails.prototype.setRelatedProducts = function($assetDetailsArea, data) {
  var $relatedProducts = $assetDetailsArea.find('#related-products').html('');
  if(!data.length) {
    $relatedProducts.html('None');
  }	
  $.each(data, function(index, product) {
    $relatedProducts.append($('<a>').attr('href', '/admin/products/' + product.slug + '/edit')
      .text(product.name).css('display', 'block'));
  });
};

$(function () {
  var selectors = {
    wrapper: $('#wrapper')
  };
  $assetDetails = new AssetDetails(selectors);
  $assetDetails.init();
});
