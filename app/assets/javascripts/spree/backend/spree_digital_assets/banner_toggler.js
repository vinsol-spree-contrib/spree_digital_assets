function BannerToggler(options){
  this.$toggleSwitches = options.$toggleSwitches;
}

BannerToggler.prototype.init = function(){
  this.$toggleSwitches.on('change', this.sendAjaxToUpdateActivate());
};

BannerToggler.prototype.sendAjaxToUpdateActivate = function(){
  var _this = this;

  return function(){
    $.ajax({
      url: _this.getToggleUrl(this),
      type: "PATCH",
      context: this,
      dataype: "json"
    })
      .done(_this.toggleEnabled)
      .fail(function(xhr, status, errorThrown){
        show_flash('error', xhr.responseJSON.error);
      });
  };

};

BannerToggler.prototype.toggleEnabled = function(response){
  $(this).data("active", response.active);
};

BannerToggler.prototype.getToggleUrl = function(element){
  if($(element).data('active')){
    return "/admin/banners/:id/deactivate".replace(":id", $(element).data('banner-id'))
  }
  else{
    return "/admin/banners/:id/activate".replace(":id", $(element).data('banner-id'))
  }
};

$(function(){

  var bannerTogglerArguments = { $toggleSwitches : $("[data-toggle-switch='yes']") },
      bannerToggler = new BannerToggler(bannerTogglerArguments);

  bannerToggler.init();
});
