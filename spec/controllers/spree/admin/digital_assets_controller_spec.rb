require 'spec_helper'

describe Spree::Admin::DigitalAssetsController do

  let(:digital_assets) { double(ActiveRecord::Relation) }
  let(:folder) { double(Spree::Folder) }
  let(:folders) { [folder] }
  let(:children) { [folder] }
  let(:user) { mock_model(Spree::User) }
  let(:digital_asset) { mock_model(Spree::DigitalAsset) }
  let(:folder_id) { '1' }
  let(:digital_asset_folder_path) { '' }

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
    allow(controller).to receive(:authorize_admin).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)
    allow(user).to receive(:generate_spree_api_key!).and_return(true)
    allow(controller).to receive(:collection).and_return(digital_assets)
    allow(digital_assets).to receive(:page).and_return(digital_assets)
    allow(digital_assets).to receive(:order).and_return(digital_assets)
  end

  describe '#index' do
    def send_request(params={})
      get :index, params
    end

    before do
      allow(digital_assets).to receive(:where).and_return(digital_assets)
      allow(digital_assets).to receive(:includes).and_return(digital_assets)
    end

    describe 'Methods' do
      it { expect(digital_assets).to receive(:order).with(created_at: :desc).and_return(digital_assets) }
      it { expect(digital_assets).to receive(:page).and_return(digital_assets) }
      it { expect(digital_assets).to receive(:includes).with(assets: { viewable: :product }).and_return(digital_assets) }

      after { send_request(folder_id: folder_id) }
    end

    describe 'Response' do
      before { send_request(folder_id: folder_id) }

      it { is_expected.to render_template :index }
    end

    describe 'Assignment' do
      before { send_request(folder_id: folder_id) }

      it { expect(assigns[:digital_assets]).to eq(digital_assets) }
    end
  end

  describe 'filter_digital_assets_by_folder' do

    def send_request(params = {})
      get :index, params
    end

    before do
      allow(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder)
      allow(digital_assets).to receive(:where).and_return(digital_assets)
      allow(folder).to receive(:id).and_return(folder_id)
      allow(digital_assets).to receive(:includes).and_return(digital_assets)
    end

    describe 'Methods' do
      it { expect(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder) }
      it { expect(digital_assets).to receive(:where).with(folder: folder).and_return(digital_assets) }
      it { expect(folder).to receive(:id).and_return(folder_id) }

      after { send_request(folder_id: folder_id) }
    end

    describe 'Assignment' do
      before { send_request(folder_id: folder_id) }

      it { expect(assigns[:current_folder]).to eq(folder) }
      it { expect(assigns[:digital_assets]).to eq(digital_assets) }
    end

  end

  describe 'current_folder_children' do

    def send_request(params = {})
      get :index, params
    end

    before do
      allow(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder)
      allow(digital_assets).to receive(:where).and_return(digital_assets)
      allow(folder).to receive(:try).with(:children).and_return(children)
      allow(folder).to receive(:id).and_return(folder_id)
      allow(controller).to receive(:build_digital_asset).and_return(true)
      allow(digital_assets).to receive(:includes).and_return(digital_assets)
    end

    context 'when folder.id present?' do

      describe 'Methods' do
        it { expect(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder) }
        it { expect(digital_assets).to receive(:where).and_return(digital_assets) }
        it { expect(folder).to receive(:try).with(:children).and_return(children) }
        it { expect(controller).to receive(:build_digital_asset).and_return(true) }

        after { send_request(folder_id: folder_id) }
      end

      it 'assigns @current_folder_children' do
        send_request(folder_id: folder_id)
        expect(assigns(:current_folder_children)).to eq(children)
      end

    end

    context 'when folder.id not present?' do
      before do
        allow(Spree::Folder).to receive(:find_by).with(id: nil)
        allow(Spree::Folder).to receive(:where).with(parent_id: nil).and_return(children)
      end

      describe 'Methods' do
        it { expect(Spree::Folder).to receive(:where).with(parent_id: nil).and_return(children) }
        it { expect(digital_assets).to receive(:where).and_return(digital_assets) }
        it { expect(controller).to receive(:build_digital_asset).and_return(true) }

        after { send_request }
      end

      it 'assigns @current_folder_children' do
        send_request
        expect(assigns(:current_folder_children)).to eq(children)
      end
    end

  end

  describe 'build_digital_asset' do

    def send_request(params = {})
      get :index, params
    end

    before do
      allow(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder)
      allow(digital_assets).to receive(:where).and_return(digital_assets)
      allow(folder).to receive(:id).and_return(folder_id)
      allow(Spree::DigitalAsset).to receive(:new).with(folder_id: folder_id).and_return(digital_asset)
      allow(digital_assets).to receive(:includes).and_return(digital_assets)
    end

    describe 'Methods' do
      it { expect(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder) }
      it { expect(digital_assets).to receive(:where).and_return(digital_assets) }
      it { expect(Spree::DigitalAsset).to receive(:new).with(folder_id: folder_id).and_return(digital_asset) }

      after { send_request(folder_id: folder_id) }
    end

    it 'assigns @digital_asset' do
      send_request(folder_id: folder_id)
      expect(assigns(:digital_asset)).to eq(digital_asset)
    end

  end

  describe '#create' do
    def send_request(params={})
      post :create, params
    end

    before do
      allow(Spree::DigitalAsset).to receive(:new).and_return(digital_asset)
      allow(digital_asset).to receive(:assign_attributes)
      allow(digital_asset).to receive(:save).and_return(true)
    end

    describe 'Response' do
      context 'successfully saved' do
        before { send_request(format: :js) }

        it { is_expected.to render_template :create }
        it { is_expected.to respond_with 200 }
      end

      context 'not saved successfully' do
        before do
          allow(digital_asset).to receive(:save).and_return(false)
          send_request(format: :js)
        end

        it { is_expected.to respond_with 422 }
      end
    end
  end

  describe '#update' do
    def send_request(params={})
      spree_put :update, params.merge(id: digital_asset.id)
    end

    before do
      allow(controller).to receive(:load_resource_instance).and_return(digital_asset)
      allow(digital_asset).to receive(:update_attributes).and_return(true)
      allow(controller).to receive(:collection_url).with(folder_id: digital_asset.folder_id).and_return(digital_asset_folder_path)
    end

    context 'successfully updated' do
      describe 'Response' do
        before { send_request }

        it { is_expected.to respond_with 302 }
        it { expect(response).to redirect_to(digital_asset_folder_path) }
      end

    end
  end

end
