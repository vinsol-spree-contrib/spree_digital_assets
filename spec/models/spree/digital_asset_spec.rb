require 'spec_helper'

describe Spree::DigitalAsset, type: :model do

  let(:folder) { Spree::Folder.create(name: 'folder') }
  let(:digital_asset) { Spree::DigitalAsset.new(folder: folder) }
  let(:approved_digital_asset) { Spree::DigitalAsset.new(folder: folder, approved: true) }
  let(:refused_digital_asset) { Spree::DigitalAsset.new(folder: folder, approved: false) }

  def attach_image(digital_asset)
    digital_asset.attachment.attach(io: File.new(Spree::Core::Engine.root + 'spec/fixtures/thinking-cat.jpg'), filename: 'thinking-cat.jpg', content_type: 'image/jpg')
  end

  def attach_non_image(digital_asset)
    digital_asset.attachment.attach(io: File.new(Spree::Core::Engine.root + 'spree_core.gemspec'), filename: 'spree_core.gemspec', content_type: 'gemspec')
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:folder) }
    it { is_expected.to have_many(:assets) }
  end

  describe 'Valdations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      context 'create' do
        before { attach_image(digital_asset) }
        it { expect { digital_asset.valid? }.to change { digital_asset.name }.from(nil).to('Thinking Cat') }
      end

      context 'update' do
        before do
          attach_image(digital_asset)
          digital_asset.save
          digital_asset.name = ''
        end

        it { expect { digital_asset.valid? }.not_to change { digital_asset.name } }
      end
    end
  end

  describe 'Scopes' do
    before do
      attach_image(approved_digital_asset)
      approved_digital_asset.save

      attach_image(refused_digital_asset)
      refused_digital_asset.save
    end

    describe '#approved' do
      it { expect(Spree::DigitalAsset.approved).to include(approved_digital_asset) }
      it { expect(Spree::DigitalAsset.approved).not_to include(refused_digital_asset) }
    end

    describe '#not-approved' do
      it { expect(Spree::DigitalAsset.not_approved).to include(refused_digital_asset) }
      it { expect(Spree::DigitalAsset.not_approved).not_to include(approved_digital_asset) }
    end
  end

  describe '#assign_default_name' do
    context 'name blank' do
      before { attach_image(digital_asset) }

      it { expect { digital_asset.send(:assign_default_name) }.to change { digital_asset.name }.from(nil).to('Thinking Cat') }
    end

    context 'name present' do
      before do
        attach_image(digital_asset)
        digital_asset.name = 'test'
      end

      it { expect { digital_asset.send(:assign_default_name) }.not_to change { digital_asset.name } }
    end
  end

  describe '#image?' do
    context 'image present' do
      before { attach_image(digital_asset) }

      it { expect(digital_asset.send(:image?)).to be true }
    end

    context 'image not present' do
      before { attach_non_image(digital_asset) }

      it { expect(digital_asset.send(:image?)).to be false }
    end
  end

end
