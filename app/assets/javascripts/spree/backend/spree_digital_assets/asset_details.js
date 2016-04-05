function AssetDetails(selectors) {
  this.wrapper = selectors.wrapper;
};

AssetDetails.prototype.init = function() {
  var _this = this;
  this.wrapper.on('click', 'div.asset-area', function(){
  	var $img = $(this).find('img');
    _this.wrapper.find('#asset-name').html($img.data('name'));
    _this.wrapper.find('#file-size').html($img.data('size'));
    _this.wrapper.find('#created-date').html($img.data('created-on'));
    _this.wrapper.find('#modified-date').html($img.data('modified-on'));
    _this.wrapper.find('#related-products').html(_this.setRelatedProducts($img.data('related-products')));
    _this.wrapper.find('.asset-details').removeClass('hide');
  });
  _this.wrapper.find('.asset-details').addClass('hide');
};

AssetDetails.prototype.setRelatedProducts = function(data) {
  var $relatedProducts = this.wrapper.find('#related-products').html('');
  if(!Object.keys(data).length) {
    $relatedProducts.html('None');
  }	
  $.each(data, function(key, value) {
    $relatedProducts.append($('<a>').attr('href', '/admin/products/' + key + '/edit').text(value).css('display', 'block'));
  });
};
$(function () {
  var selectors = {
    wrapper: $('#wrapper')
  };
  var assetDetails = new AssetDetails(selectors);
  assetDetails.init();
});