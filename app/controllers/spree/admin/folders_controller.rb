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
        if @object.destroy
          render json: { folder: { descendant_ids: descendant_ids, id: @object.id, parent_id: @object.parent_id }}
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end
    end

  end
end
