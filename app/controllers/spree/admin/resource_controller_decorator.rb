Spree::Admin::ResourceController.class_eval do
  def create
    invoke_callbacks(:create, :before)
    if SUPPORTED_IMAGE_FORMATS.include? Spree::DigitalAsset.find(permitted_resource_params[:digital_asset_id]).try(:attachment_content_type)
      @object.attributes = permitted_resource_params
    end
    if @object.save
      invoke_callbacks(:create, :after)
      flash[:success] = flash_message_for(@object, :successfully_created)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render layout: false }
      end
    else
      invoke_callbacks(:create, :fails)
      respond_with(@object) do |format|
        format.html { render action: :new }
        format.js { render layout: false }
      end
    end
  end
end
