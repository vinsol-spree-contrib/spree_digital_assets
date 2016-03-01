module Spree
  class DigitalAsset < Spree::Base
    belongs_to :folder, required: true

    has_attached_file :attachment, styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' }
    do_not_validate_attachment_file_type :attachment

    validates :name, :attachment, presence: true
  end
end
