require 'spec_helper'

describe Spree::Admin::DigitalAssetsController do
  let(:digital_assets) { double(ActiveRecord::Relation) }
  let(:folder) { double(Spree::Folder) }
  before(:each) do
    @user = mock_model(Spree::User)
    allow(controller).to receive(:spree_current_user).and_return(@user)
    allow(controller).to receive(:authorize_admin).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)
    allow(@user).to receive(:generate_spree_api_key!).and_return(true)
    allow(controller).to receive(:collection).and_return(digital_assets)
  end

  describe 'GET#index' do
    def send_request(params={})
      get :index, params
    end

    before do
      allow(digital_assets).to receive(:page).and_return(digital_assets)
      allow(digital_assets).to receive(:per).and_return(digital_assets)
    end

    describe 'Methods' do
      context 'when params folder_id not present' do
        it { expect(digital_assets).to receive(:page).and_return(digital_assets) }
        it { expect(digital_assets).to receive(:per).and_return(digital_assets) }
        after { send_request }
      end
      context 'when folder_id present' do
        before do
          allow(Spree::Folder).to receive(:find_by).and_return(folder)
          allow(folder).to receive(:present?).and_return(true)
          allow(folder).to receive(:self_and_descendants).and_return([folder])
          allow(digital_assets).to receive(:where).and_return(digital_assets)
          allow(folder).to receive(:id)
        end
        it { expect(Spree::Folder).to receive(:find_by).and_return(folder) }
        it { expect(folder).to receive(:present?).and_return(true) }
        it { expect(folder).to receive(:self_and_descendants).and_return([folder]) }
        after { send_request(folder_id: 1) }
      end
    end

    describe 'Response' do
      before { send_request }
      it { is_expected.to render_template :index }
    end

  end
end
