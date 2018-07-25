Deface::Override.new(
  virtual_path: 'spree/shared/_header',
  name: 'add_banner_div_to_layout',
  insert_top: "div#spree-header > div.container",
  partial: 'spree/layouts/banner_div'
)
