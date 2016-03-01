require 'spec_helper'

describe Spree::Admin::ImagesController do

  let(:digital_assets) { double(ActiveRecord::Relation) }
  let(:folders) { double(ActiveRecord::Relation) }
  let(:products) { double(ActiveRecord::Relation) }
  let(:product) { mock_model(Spree::Product) }
  let(:variants) { double(ActiveRecord::Relation) }
  let(:variant) { double(Spree::Variant) }

  before do
    allow(Spree::Product).to receive(:friendly).and_return(products)
    allow(products).to receive(:includes).and_return(products)
    allow(products).to receive(:find).and_return(product)
    allow(product).to receive(:variants).and_return(variants)
    allow(variants).to receive(:map).and_return(variants)
    allow(product).to receive(:master).and_return(variant)
    allow(variant).to receive(:id).and_return(1)
    allow(variants).to receive(:insert).and_return(variants)
  end

  def send_request
    get :new, product_id: 1
  end

  before do
    allow(controller).to receive(:spree_current_user).and_return(@user)
    allow(controller).to receive(:authorize_admin).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)
    allow(@user).to receive(:generate_spree_api_key!).and_return(true)
  end

  describe '#load_folder_and_digital_assets' do
    before do
      allow(Spree::Folder).to receive(:all).and_return(folders)
      allow(Spree::DigitalAsset).to receive(:page).and_return(digital_assets)
      allow(digital_assets).to receive(:per).and_return(digital_assets)
      send_request
    end

    it { expect(assigns[:folders]).to eq(folders) }
    it { expect(assigns[:digital_assets]).to eq(digital_assets) }
  end

end
