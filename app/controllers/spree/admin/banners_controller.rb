module Spree
  module Admin
    class BannersController < ResourceController

      before_action :load_banner, only: [:edit, :update, :destroy, :activate, :deactivate]
      before_action :load_folders, only: [:new, :create, :edit, :update]
      before_action :create_banner_and_images, only: [:create]

      def create
        if @banner.save
          flash[:success] = Spree.t(:successfully_created_banner)
          redirect_to admin_banners_path
        else
          render :new
        end
      end

      def index
        params[:q] ||= {}
        @search = Spree::Banner.order(created_at: :desc).ransack(params[:q])
        @banners = @search.result(distinct: true).page(params[:page]).per(params[:per_page])
      end

      def activate
        if @banner.activate
          render json: { active: 'Yes' }, status: 200
        else
          render json: { error: @banner.errors.full_messages.join(', ') }, status: 422
        end
      end

      def deactivate
        if @banner.deactivate
          render json: { active: 'No' }, status: 200
        else
          render json: { error: @banner.errors.full_messages.join(', ') }, status: 422
        end
      end

      def toggle_banner_active_status
        if @banner.change_active_status
          flash[:success] = Spree.t(:successfully_updated_banner)
        else
          flash[:notice] = @banner.errors.full_messages.join
        end
        redirect_to admin_banners_path
      end

      def update
        if @banner.update(permitted_params)
          flash[:success] = Spree.t(:successfully_updated_banner)
          redirect_to admin_banners_path
        else
          render :edit
        end
      end

      private

        def create_banner_and_images
          @banner = Banner.new(permitted_params)
          if permitted_resource_params[:images][:digital_asset_id].present?
            @banner.images << Spree::Image.new(permitted_resource_params[:images])
          end
        end

        def load_folders
          @folders = Spree::Folder.all
          @digital_assets = Spree::DigitalAsset.approved.page(params[:page])
        end

        def permitted_params
          params.require(:banner).permit(:title, :attachment, :link, :active, :mobile_banner)
        end

        def load_banner
          @banner = Spree::Banner.find_by(id: params[:id])
        end

    end
  end

end
