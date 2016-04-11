module Spree
  module Admin

    class FoldersController < ResourceController

      def create
        @object.assign_attributes(permitted_resource_params)
        if @object.save
          render json: { folder: { name: @object.name, id: @object.id, parent_id: @object.parent_id }}
        else
          respond_to_failure
        end
      end

      def update
        if @object.update_attributes(permitted_resource_params)
          render json: { folder: { name: @object.name, id: @object.id, parent_id: @object.parent_id }}
        else
          respond_to_failure
        end
      end

      def destroy
        if @object.destroy
          respond_to do |format|
            format.html { redirect_to admin_digital_assets_path(folder_id: @object.parent_id), notice: Spree.t('folders.success') }
            format.json { render json: { folder: { id: @object.id } } }
          end
        else
          respond_to_failure
        end
      end

      private

        def respond_to_failure
          respond_to do |format|
            format.html { redirect_to admin_digital_assets_path(folder_id: @object.id),
                            notice: Spree.t('folders.failure', error_messages: @object.errors.full_messages.to_sentence) }
            format.json { render json: { errors: @object.errors.full_messages.to_sentence } }
          end
        end
      
    end

  end
end
