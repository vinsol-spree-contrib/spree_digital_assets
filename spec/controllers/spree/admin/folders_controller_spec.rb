require 'spec_helper'

describe Spree::Admin::FoldersController do

  let(:folder) { mock_model(Spree::Folder) }
  let(:user) { mock_model(Spree::User) }

  before do
    allow(controller).to receive(:spree_current_user).and_return(user)
    allow(controller).to receive(:authorize_admin).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)
    allow(user).to receive(:generate_spree_api_key!).and_return(true)
  end

  describe '#create' do
    def send_request(params={})
      spree_post :create, params
    end

    before do
      allow(Spree::Folder).to receive(:new).and_return(folder)
      allow(folder).to receive(:assign_attributes)
      allow(folder).to receive(:save).and_return(true)
    end

    context 'successfully created' do

      describe 'Methods' do
        it { expect(folder).to receive(:assign_attributes).and_return(folder) }
        it { expect(folder).to receive(:save).and_return(true) }

        after { send_request(format: :json) }
      end

      describe 'Response' do
        before { send_request(format: :json) }

        it { expect(response.body['folder']).not_to be_nil }
      end

    end

    context 'not created successfully' do
      before do
        allow(folder).to receive(:save).and_return(false)
      end

      describe 'Methods' do
        it { expect(folder).to receive(:assign_attributes).and_return(folder) }
        it { expect(folder).to receive(:save).and_return(false) }

        after { send_request(format: :json) }
      end

      describe 'Response' do
        before { send_request(format: :json) }

        it { expect(response.body['errors']).not_to be_nil }
      end
    end
  end

  describe '#update' do
    def send_request(params={})
      spree_put :update, params.merge(id: folder.id)
    end

    before do
      allow(controller).to receive(:load_resource_instance).and_return(folder)
      allow(folder).to receive(:update_attributes).and_return(true)
    end

    context 'successfully updated' do

      describe 'Methods' do
        it { expect(folder).to receive(:update_attributes).and_return(folder) }

        after { send_request(format: :json) }
      end

      describe 'Response' do
        before { send_request(format: :json) }

        it { expect(response.body['folder']).not_to be_nil }
      end

    end

    context 'not updated successfully' do

      before do
        allow(folder).to receive(:update_attributes).and_return(false)
      end

      describe 'Methods' do
        it { expect(folder).to receive(:update_attributes).and_return(false) }

        after { send_request(format: :json) }
      end

      describe 'Response' do
        before { send_request(format: :json) }

        it { expect(response.body['errors']).not_to be_nil }
      end
    end
  end

  describe '#destroy' do
    def send_request(params={})
      spree_put :destroy, params.merge(id: folder.id)
    end

    before do
      allow(controller).to receive(:load_resource_instance).and_return(folder)
      allow(folder).to receive(:destroy).and_return(true)
    end

    context 'when request.json?' do
      context 'successfully destroyed' do

        describe 'Methods' do
          it { expect(folder).to receive(:destroy).and_return(true) }

          after { send_request(format: :json) }
        end

        describe 'Response' do
          before { send_request(format: :json) }

          it { expect(response.body['folder']).not_to be_nil }
        end

      end

      context 'not destroyed successfully' do

        before do
          allow(folder).to receive(:destroy).and_return(false)
        end

        describe 'Methods' do
          it { expect(folder).to receive(:destroy).and_return(false) }

          after { send_request(format: :json) }
        end

        describe 'Response' do
          before { send_request(format: :json) }

          it { expect(response.body['errors']).not_to be_nil }
        end
      end
    end

    context 'when request.html?' do
      context 'successfully destroyed' do

        describe 'Methods' do
          it { expect(folder).to receive(:destroy).and_return(true) }

          after { send_request }
        end

        describe 'Response' do
          before { send_request }

          it { is_expected.to redirect_to admin_digital_assets_path(folder_id: folder.parent_id) }
        end

      end

      context 'not destroyed successfully' do

        before do
          allow(folder).to receive(:destroy).and_return(false)
        end

        describe 'Methods' do
          it { expect(folder).to receive(:destroy).and_return(false) }

          after { send_request }
        end

        describe 'Response' do
          before { send_request }

          it { is_expected.to redirect_to admin_digital_assets_path(folder_id: folder.id) }
        end
      end
    end

  end
end
