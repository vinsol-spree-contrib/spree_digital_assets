Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'add_banner_tab',
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item Spree.t(:banner), admin_banners_path %>"

)
