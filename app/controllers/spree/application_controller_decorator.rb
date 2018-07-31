ApplicationController.class_eval do

  before_action :detect_device_variant

  private

    def detect_device_variant
      request.variant = :phone if browser.device.mobile?
    end
end
