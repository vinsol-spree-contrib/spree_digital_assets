SUPPORTED_IMAGE_FORMATS = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/bmp"]
SUPPORTED_IMAGES_REGEX = Regexp.new('\A(' + SUPPORTED_IMAGE_FORMATS.join('|') + ')\Z')

module Spree
  class DigitalAsset < Spree::Base
    belongs_to :folder
    has_many :assets

    has_one_attached :attachment

    validates :name, :attachment, :folder, presence: true
    before_save :image?
    before_validation :assign_default_name, on: :create

    scope :approved, -> { where(approved: true) }
    scope :not_approved, -> { where(approved: false) }

    def associated_products
      products = []
      assets.where(viewable_type: 'Spree::Variant').each do |asset|
        products << asset.viewable.product
      end
      products.uniq
    end

    private
      def image?
        (attachment.content_type =~ SUPPORTED_IMAGES_REGEX).present?
      end

      def assign_default_name
        self.name = attachment.filename.to_s.titleize.truncate(255) if name.blank?
      end
  end
end
