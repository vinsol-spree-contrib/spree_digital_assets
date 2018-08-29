Spree::Image.class_eval do
  has_attached_file :attachment,
                      styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>', banner: '1022x60>' },
                      default_style: :product,
                      url: '/spree/products/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
end
