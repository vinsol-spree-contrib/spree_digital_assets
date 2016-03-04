require 'spec_helper'

describe Spree::Admin::DigitalAssetsController do

  let(:digital_assets) { double(ActiveRecord::Relation) }
  let(:folder) { double(Spree::Folder) }
  let(:folders) { [folder] }
  let(:user) { mock_model(Spree::User) }
  let(:folder_id) { '1' }

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
    allow(controller).to receive(:authorize_admin).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)
    allow(user).to receive(:generate_spree_api_key!).and_return(true)
    allow(controller).to receive(:collection).and_return(digital_assets)
    allow(digital_assets).to receive(:page).and_return(digital_assets)
    allow(digital_assets).to receive(:order).and_return(digital_assets)
  end

  describe 'GET#index' do
    def send_request(params={})
      get :index, params
    end

    describe 'Methods' do
      context 'when params folder_id not present' do
        it { expect(digital_assets).to receive(:page).and_return(digital_assets) }
        it { expect(digital_assets).to receive(:order).with(created_at: :desc).and_return(digital_assets) }

        after { send_request }
      end
    end

    describe 'Response' do
      before { send_request }

      it { is_expected.to render_template :index }
    end

    describe 'Assignment' do
      before { send_request }

      it { expect(assigns[:digital_assets]).to eq(digital_assets) }
    end

  end

  describe 'filter_digital_assets_by_folder' do

    def send_request(params={})
      get :index, params
    end

    before do
      allow(Spree::Folder).to receive(:find_by).and_return(folder)
      allow(folder).to receive(:present?).and_return(true)
      allow(folder).to receive(:self_and_descendants).and_return(folders)
      allow(digital_assets).to receive(:where).and_return(digital_assets)
      allow(folder).to receive(:id).and_return(folder_id)
    end

    describe 'Methods' do
      it { expect(Spree::Folder).to receive(:find_by).with(id: folder_id).and_return(folder) }
      it { expect(folder).to receive(:self_and_descendants).and_return(folders) }

      after { send_request(folder_id: folder_id) }
    end

    describe 'Assignment' do
      before { send_request(folder_id: folder_id) }

      it { expect(assigns[:current_folder]).to eq(folder) }
      it { expect(assigns[:digital_assets]).to eq(digital_assets) }
    end

  end

end
