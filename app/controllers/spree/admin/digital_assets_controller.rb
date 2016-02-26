module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      def index
        if params[:folder_id].present?
          @current_folder = Spree::Folder.find_by(id: params[:folder_id])
          @digital_assets = @digital_assets.where(folder: @current_folder.self_and_descendants) if @current_folder.present?
        end
      end

    end

  end
end
