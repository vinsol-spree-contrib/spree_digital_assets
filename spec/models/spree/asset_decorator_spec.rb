require 'spec_helper'

describe Spree::Asset, :type => :model do

  let(:folder) { Spree::Folder.create(name: 'folder') }
  let(:digital_asset) { Spree::DigitalAsset.create!(name: 'abc', folder: folder, attachment: File.new(Spree::Core::Engine.root + "spec/fixtures" + 'thinking-cat.jpg')) }
  let(:image) { Spree::Image.new }

  describe '#build_from_digital_asset' do
    context 'when valid id passed' do
      before do
        image.digital_asset_id = digital_asset.id
        image.save
      end

      it { expect(image.attachment_file_name).to eq(digital_asset.attachment_file_name) }
    end
    context 'when valid id not passed' do
      before do
        image.digital_asset_id = 5
        image.save
      end

      it { expect(image.errors[:base]).to include('invalid digital_asset_id passed') }
    end
  end

end
