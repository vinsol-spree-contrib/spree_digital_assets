module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      before_action :filter_digital_assets_by_folder, :build_digital_asset, only: :index

      def index
        @digital_assets = @digital_assets.order(created_at: :desc).page(params[:page])
        render 'view_more' if params[:page].to_i > 1
      end

      private
        def filter_digital_assets_by_folder
          if params[:folder_id].present? && (@current_folder = Spree::Folder.find_by(id: params[:folder_id]))
            @digital_assets = @digital_assets.where(folder: @current_folder.self_and_descendants)
          end
        end

        def build_digital_asset
          @digital_asset = Spree::DigitalAsset.new(folder_id: @current_folder.try(:id))
        end

    end

  end
end
