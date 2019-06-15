require 'spec_helper'

describe Spree::Asset, type: :model do

  let(:folder) { Spree::Folder.create(name: 'folder') }
  let(:digital_asset) do
    digital_asset = Spree::DigitalAsset.new(name: 'abc', folder: folder)
    digital_asset.attachment.attach(io: File.new(Spree::Core::Engine.root + 'spec/fixtures/thinking-cat.jpg'), filename: 'thinking-cat.jpg', content_type: 'image/jpg')
    digital_asset.save
    digital_asset
  end
  let(:image) { Spree::Image.new }

  describe 'Associations' do
    it { is_expected.to belong_to(:digital_asset) }
  end

  describe 'before_validation' do
    context 'digital_asset_id not changed' do
      it { expect(image).not_to receive(:build_from_digital_asset) }

      after { image.valid? }
    end

    context 'digital_asset_id changed' do
      before do
        image.digital_asset_id = digital_asset.id
      end

      it { expect(image).to receive(:build_from_digital_asset) }

      after { image.valid? }
    end
  end

end
