Spree::Admin::ImagesController.class_eval do
  before_action :load_folder_and_digital_assets, only: [:new, :edit, :create, :update]

  private
    def load_folder_and_digital_assets
      @folders = Spree::Folder.all
      @digital_assets = Spree::DigitalAsset.page(params[:page]).per(36)
    end
end
