require 'spec_helper'

describe Spree::DigitalAsset, type: :model do

  let(:folder) { Spree::Folder.create(name: 'folder') }
  let(:digital_asset) { Spree::DigitalAsset.new(folder: folder, attachment: File.new(Spree::Core::Engine.root + "spec/fixtures" + 'thinking-cat.jpg'), approved: true) }
  let(:pdf_digital_asset) { Spree::DigitalAsset.new(folder: folder, attachment: File.new(Spree::Core::Engine.root + 'spree_core.gemspec')) }
  let(:not_approved_digital_asset) { Spree::DigitalAsset.new(folder: folder, attachment: File.new(Spree::Core::Engine.root + "spec/fixtures" + 'thinking-cat.jpg'), approved: false) }

  it { is_expected.to have_attached_file(:attachment) }

  describe 'Associations' do
    it { is_expected.to belong_to(:folder) }
    it { is_expected.to have_many(:assets) }
  end

  describe 'Valdations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:attachment) }
    it { is_expected.to validate_presence_of(:folder) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      context 'create' do
        it { expect { digital_asset.valid? }.to change { digital_asset.name }.from(nil).to('Thinking Cat') }
      end

      context 'update' do
        before do
          digital_asset.save
          digital_asset.name = ''
        end

        it { expect { digital_asset.valid? }.not_to change { digital_asset.name } }
      end
    end
  end

  describe 'Scopes' do
    before do
      digital_asset.save
      not_approved_digital_asset.save
    end

    describe '#approved' do
      it { expect(Spree::DigitalAsset.approved).to include(digital_asset) }
      it { expect(Spree::DigitalAsset.approved).not_to include(not_approved_digital_asset) }
    end

    describe '#not-approved' do
      it { expect(Spree::DigitalAsset.not_approved).to include(not_approved_digital_asset) }
      it { expect(Spree::DigitalAsset.not_approved).not_to include(digital_asset) }
    end
  end

  describe '#assign_default_name' do
    context 'name blank' do
      it { expect { digital_asset.send(:assign_default_name) }.to change { digital_asset.name }.from(nil).to('Thinking Cat') }
    end

    context 'name present' do
      before { digital_asset.name = 'test' }

      it { expect { digital_asset.send(:assign_default_name) }.not_to change { digital_asset.name } }
    end
  end

  describe '#image?' do
    context 'image present' do
      it { expect(digital_asset.send(:image?)).to be true }
    end

    context 'image not present' do
      it { expect(pdf_digital_asset.send(:image?)).to be false }
    end
  end

end
