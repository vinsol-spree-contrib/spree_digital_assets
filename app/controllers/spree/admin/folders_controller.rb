module Spree
  module Admin

    class FoldersController < ResourceController

      before_action :load_assets_and_folders, only: [:create, :update]

      def create
        @object.assign_attributes(permitted_resource_params)
        if @object.save
          render json: { name: @object.name, id: @object.id, parent_id: @object.parent_id, commit: 'create' }, status: 200
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      def update
        @object.update_attributes(permitted_resource_params.delete_if { |_k, v| v.blank? })
        if @object.save
          render json: { name: @object.name, id: @object.id, parent_id: @object.parent_id, commit: 'update' }, status: 200
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      def destroy
        if @object.destroy
          render json: {id: @object.id, commit: 'delete' }, status: 200
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      private

        def current_folder
          @current_folder ||= Spree::Folder.find_by(id: params[:folder_id])
        end

        def load_assets_and_folders
          @folders = Spree::Folder.where(parent_id: current_folder.id).page(params[:page])
          @digital_assets = Spree::DigitalAsset.where(folder_id: @current_folder.id).page(params[:page])
        end
    end

  end
end
