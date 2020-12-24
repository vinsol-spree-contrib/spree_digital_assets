Spree::Admin::ImagesController.class_eval do
  before_action :load_folder_and_digital_assets, only: [:new, :edit, :create, :update]
  before_action :assign_image_attributes, only: :update

  def update
    invoke_callbacks(:update, :before)
    if !@object.errors.any? && @object.save
      invoke_callbacks(:update, :after)
      respond_with(@object) do |format|
        format.html do
          flash[:success] = flash_message_for(@object, :successfully_updated)
          redirect_to location_after_save
        end
        format.js { render layout: false }
      end
    else
      invoke_callbacks(:update, :fails)
      respond_with(@object) do |format|
        format.html { render action: :edit }
        format.js { render layout: false }
      end
    end
  end

  private
    def load_folder_and_digital_assets
      @folders = Spree::Folder.all
      @digital_assets = Spree::DigitalAsset.approved.page(params[:page])
    end

    def assign_image_attributes
      if SUPPORTED_IMAGE_FORMATS.include? Spree::DigitalAsset.find_by(id: permitted_resource_params[:digital_asset_id]).try(:attachment).try(:content_type)
        @object.attributes = permitted_resource_params
      else
        @object.errors.add(:attachment, :not_allowed_content_type)
      end
    end
end
