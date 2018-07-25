module Spree
  class Banner < Spree::Base
    has_attached_file :attachment, styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' },
                      url: '/spree/banner/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/banner/:id/:style/:basename.:extension'

    validates_attachment :attachment, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

    with_options presence: true do
      validates :title, uniqueness: true
      validates :link
      validates :attachment
    end

    scope :active, -> { where(active: true) }
  end
end
