class Admin::PaymentSettingsController < Admin::BaseController
    
    layout 'admin'
    
    def index
      @payment_settings = PaymentSetting.all
    end
  
    def edit
      @payment_setting = PaymentSetting.find(params[:id])
    end
  
    def update
      @payment_setting = PaymentSetting.find(params[:id])
      if @payment_setting.update(payment_setting_params)
        redirect_to admin_payment_settings_path, notice: 'Payment setting updated successfully.'
      else
        render :edit
      end
    end
  
    private
  
    def payment_setting_params
      params.require(:payment_setting).permit(:key, :value)
    end
end
  