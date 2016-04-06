module Spree
  module Admin

    class FoldersController < ResourceController

      def create
        @object.assign_attributes(permitted_resource_params)
        if @object.save
          render json: { folder: { name: @object.name, id: @object.id, parent_id: @object.parent_id }}
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      def update
        @object.update_attributes(permitted_resource_params.delete_if { |_k, v| v.blank? })
        if @object.save
          render json: { folder: { name: @object.name, id: @object.id, parent_id: @object.parent_id }}
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      def destroy
        descendant_ids = @object.self_and_descendants.map(&:id)
        respond_to do |format|
          if @object.destroy
            format.html { redirect_to admin_digital_assets_path(folder_id: @object.parent_id), notice: Spree.t('folders.success') }
            format.json { render json: { folder: { descendant_ids: descendant_ids, id: @object.id, parent_id: @object.parent_id }}}
          else
            format.html { redirect_to admin_digital_assets_path(folder_id: @object.id),
                            notice: Spree.t('folders.failure', error_messages: @object.errors.messages[:base].join(',')) }
            format.json { render json: { errors: @object.errors.full_messages.to_sentence }}
          end
        end
      end
    end

  end
end
