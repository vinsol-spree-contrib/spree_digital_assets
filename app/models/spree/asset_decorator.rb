Spree::Asset.class_eval do

  belongs_to :digital_asset, optional: true

  before_validation :build_from_digital_asset, if: :digital_asset_id_changed?

  private
    def build_from_digital_asset
      digital_asset = Spree::DigitalAsset.approved.find_by(id: digital_asset_id)
      if digital_asset.present?
        self.attachment.attach(io: open(Rails.application.routes.url_helpers.url_for(digital_asset.attachment)), filename: digital_asset.attachment.filename.to_s, content_type: digital_asset.attachment.content_type)
      else
        errors.add(:base, 'invalid digital asset id passed')
        throw(:abort)
      end
    end

end
