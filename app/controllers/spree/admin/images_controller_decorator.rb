Spree::Admin::ImagesController.class_eval do
  before_action :load_folder_and_digital_assets, only: [:new, :edit, :create, :update]

  def create
    invoke_callbacks(:create, :before)
    # checking whether the asset is an supported image format.
    if SUPPORTED_IMAGE_FORMATS.include? Spree::DigitalAsset.find_by(id: permitted_resource_params[:digital_asset_id]).try(:attachment).try(:content_type)
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

  private
    def load_folder_and_digital_assets
      @folders = Spree::Folder.all
      @digital_assets = Spree::DigitalAsset.approved.page(params[:page])
    end
end
