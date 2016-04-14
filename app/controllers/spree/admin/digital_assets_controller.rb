module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      before_action :filter_digital_assets_by_folder, :current_folder_children, :build_digital_asset, only: :index

      def index
        @digital_assets = @digital_assets.order(created_at: :desc).page(params[:page])
        @digital_assets = @digital_assets.includes(assets: { viewable: :product })
        render 'view_more' if params[:view_more].present?
      end

      def create
        @object.assign_attributes(permitted_resource_params)
        if @object.save
          render layout: false
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      private

        def filter_digital_assets_by_folder
          @digital_assets = @digital_assets.where(folder: current_folder)
        end

        def current_folder
          @current_folder ||= Spree::Folder.find_by(id: params[:folder_id])
        end

        def current_folder_children
          @current_folder_children = current_folder.try(:children) || Spree::Folder.where(parent_id: nil)
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
