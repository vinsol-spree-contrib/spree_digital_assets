module Spree
  class Banner < Spree::Base

    URL_VALIDATION_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

    has_attached_file :attachment, styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' },
                      url: '/spree/banner/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/banner/:id/:style/:basename.:extension'


    validates_attachment :attachment, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
    validate :only_one_mobile_banner

    with_options presence: true do
      validates :title, uniqueness: true
      validates :link
      validates :attachment
    end

    validates_format_of :link, with: URL_VALIDATION_REGEX, multiline: true, allow_blank: true

    scope :active, -> { where(active: true) }
    scope :mobile_active_banner, -> { where(mobile_banner: true, active: true) }

    before_destroy :restrict_if_active

    def change_active_status
      if active?
        update_columns(active: false, mobile_banner: false)
      else
        update_column(:active, true)
      end
    end

    private

      def only_one_mobile_banner
        if mobile_banner?
          if !active?
            errors.add(:active, Spree.t(:only_active_mobile_banner))
          elsif other_mobile_banner_active?
            errors.add(:base, Spree.t(:only_one_mobile_banner))
          end
        end
      end

      def other_mobile_banner_active?
        (Banner.mobile_active_banner - [self]).length > 0
      end

      def restrict_if_active
        if active?
          errors.add(:base, Spree.t(:cannot_delete_active_banner))
          throw(:abort)
        end
      end

  end
end
