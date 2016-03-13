module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      before_action :filter_digital_assets_by_folder, :build_digital_asset, only: :index

      def index
        @digital_assets = @digital_assets.order(created_at: :desc).page(params[:page])
        render 'view_more' if params[:page].to_i > 1
      end

      def create
        @object.attributes = permitted_resource_params
        unless @object.save
          render json: { errors: @object.errors.full_messages.join(", ") }, status: 422
        end
      end

      private
        def filter_digital_assets_by_folder
          if params[:folder_id].present? && load_current_folder
            @digital_assets = @digital_assets.where(folder: @current_folder.self_and_descendants)
          end
        end

        def load_current_folder
          @current_folder = Spree::Folder.find_by(id: params[:folder_id])
        end

        def build_digital_asset
          @digital_asset = Spree::DigitalAsset.new(folder_id: @current_folder.try(:id))
        end

        def location_after_save
          collection_url(folder_id: @digital_asset.folder_id)
        end

    end

  end
end
