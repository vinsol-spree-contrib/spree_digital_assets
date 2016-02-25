module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      def index
        @digital_assets = @digital_assets.where(folder_id: params[:folder_id]) if params[:folder_id].present?
      end

    end

  end
end
