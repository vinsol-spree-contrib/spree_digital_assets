Deface::Override.new(virtual_path: 'spree/layouts/admin',
  name: 'add_folder_form',
  :insert_top => "#main-part",
  partial: 'spree/admin/shared/new_folder_form')
