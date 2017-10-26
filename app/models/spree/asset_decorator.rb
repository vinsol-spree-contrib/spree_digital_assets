Spree::Asset.class_eval do

  belongs_to :digital_asset

  before_validation :build_from_digital_asset, if: :digital_asset_id_changed?

  private
    def build_from_digital_asset
      digital_asset = Spree::DigitalAsset.approved.find_by(id: digital_asset_id)
      if digital_asset.present?
        self.attachment = digital_asset.attachment
      else
        errors.add(:base, 'invalid digital asset id passed')
        throw(:abort)
      end
    end

end
