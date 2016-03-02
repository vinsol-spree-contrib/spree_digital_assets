module Spree
  class DigitalAsset < Spree::Base
    belongs_to :folder, required: true

    has_attached_file :attachment, styles: { small: '100x100>' }

    do_not_validate_attachment_file_type :attachment

    validates :name, :attachment, presence: true
  end
end
