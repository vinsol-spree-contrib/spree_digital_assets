module Spree
  module Admin

    class BannersController < ResourceController

      before_action :load_banner, only: [:edit, :update, :destroy, :toggle_banner_active_status]

      def create
        @banner = Banner.new(permitted_params)
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

      def toggle_banner_active_status
        if @banner.toggle!(:active)
          flash[:success] = Spree.t(:successfully_updated_banner)
        else
          flash[:danger] = Spree.t(:error)
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

        def permitted_params
          params.require(:banner).permit(:title, :attachment, :link, :active)
        end

        def load_banner
          @banner = Spree::Banner.find_by(id: params[:id])
        end

    end
  end

end
