function AssetDetails(selectors) {
  this.wrapper = selectors.wrapper;
};

AssetDetails.prototype.init = function() {
  var _this = this;
  this.wrapper.on('click', 'div.asset-area', function(){
    _this.setAttributes($(this).find('img'));
    _this.wrapper.find('.asset-details').removeClass('hide');
  });
};

AssetDetails.prototype.setAttributes = function($img) {
  this.wrapper.find('#asset-name').html($img.data('name'));
  this.wrapper.find('#file-size').html($img.data('size'));
  this.wrapper.find('#created-date').html($img.data('created-on'));
  this.wrapper.find('#modified-date').html($img.data('modified-on'));
  this.wrapper.find('#related-products').html(this.setRelatedProducts($img.data('related-products')));
};

AssetDetails.prototype.setRelatedProducts = function(data) {
  var $relatedProducts = this.wrapper.find('#related-products').html('');
  if(!data.length) {
    $relatedProducts.html('None');
  }	
  $.each(data, function(index, product) {
    $relatedProducts.append($('<a>').attr('href', '/admin/products/' + product[0] + '/edit')
      .text(product[1]).css('display', 'block'));
  });
};

$(function () {
  var selectors = {
    wrapper: $('#wrapper')
  };
  var assetDetails = new AssetDetails(selectors);
  assetDetails.init();
});
