Deface::Override.new(virtual_path: 'spree/admin/images/_form',
  name: 'add_upload_digital_asset_button_to_image_form',
  replace: "[data-hook='file'], #file[data-hook]",
  partial: 'spree/admin/images/upload_digital_asset',
  original: 'b04679ef409bc2b16788eb8b53fa730e1a9e0cc9')
