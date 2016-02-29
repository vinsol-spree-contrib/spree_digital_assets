module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      before_action :filter_digital_assets_by_folder, if: 'params[:folder_id].present?'

      def index
        @digital_assets = @digital_assets.page(params[:page]).per(36)
        render 'view_more' if params[:page].to_i > 1
      end

      def filter_digital_assets_by_folder
        @current_folder = Spree::Folder.find_by(id: params[:folder_id])
        @digital_assets = @digital_assets.where(folder: @current_folder.self_and_descendants) if @current_folder.present?
      end

    end

  end
end
