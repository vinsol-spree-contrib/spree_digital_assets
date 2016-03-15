require 'spec_helper'

describe Spree::Asset, :type => :model do

  let(:folder) { Spree::Folder.create(name: 'folder') }
  let(:digital_asset) { Spree::DigitalAsset.create!(name: 'abc', folder: folder, attachment: File.new(Spree::Core::Engine.root + "spec/fixtures" + 'thinking-cat.jpg')) }
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

  describe '#build_from_digital_asset' do
    context 'when valid digital_asset_id' do
      before do
        image.digital_asset_id = digital_asset.id
        image.save
      end

      it { expect(image.attachment_file_name).to eq(digital_asset.attachment_file_name) }
    end

    context 'when invalid digital_asset_id' do
      before do
        image.digital_asset_id = 5
        image.save
      end

      it { expect(image.errors[:base]).to include('invalid digital asset id passed') }
    end
  end

end
