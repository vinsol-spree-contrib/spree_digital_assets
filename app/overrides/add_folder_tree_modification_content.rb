Deface::Override.new(virtual_path: 'spree/layouts/admin',
  name: 'add_folder_tree_modification_content',
  :insert_top => "#main-part",
  partial: 'spree/admin/shared/modification_content')
