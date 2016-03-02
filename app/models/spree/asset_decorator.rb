Spree::Asset.class_eval do
  attr_accessor :digital_asset_id

  before_validation :build_from_digital_asset, if: 'digital_asset_id.present?'

  private
    def build_from_digital_asset
      digital_asset = Spree::DigitalAsset.find_by(id: digital_asset_id)
      if digital_asset.present?
        self.attachment = digital_asset.attachment
      else
        errors.add(:base, 'invalid digital_asset_id passed')
      end
    end

end
