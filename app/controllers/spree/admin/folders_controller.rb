module Spree
  module Admin

    class FoldersController < ResourceController

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
    end

  end
end
