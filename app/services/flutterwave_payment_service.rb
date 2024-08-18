# app/services/flutterwave_payment_service.rb
class FlutterwavePaymentService
    def initialize(membership)
      @membership = membership
      @api_key = "FLWSECK_TEST-5888bc2d2331e6137f56fb83be4484f7-X" # Replace with your actual secret key
    end
  
    def initiate_payment
      payment_data = {
        tx_ref: SecureRandom.hex(10), # Unique transaction reference
        amount: 100.0, # Replace with your desired amount logic
        currency: 'GHS',
        redirect_url: payment_success_url,
        payment_options: 'card, mobilemoneyghana',
        customer: {
          email: @membership.email,
          phonenumber: @membership.phone,
          name: "#{@membership.first_name} #{@membership.last_name}"
        },
        customizations: {
          title: 'Membership Registration Payment',
          description: 'Payment for membership registration',
          logo: 'https://yourwebsite.com/logo.png' # Replace with your logo URL
        }
      }
  
      response = HTTParty.post(
        "https://api.flutterwave.com/v3/payments",
        headers: {
          "Authorization" => "Bearer #{@api_key}",
          "Content-Type" => "application/json"
        },
        body: payment_data.to_json
      )
  
      if response.code == 200
        { success: true, payment_link: response['data']['link'] }
      else
        { success: false, error: response['message'] }
      end
    end
  
    private
  
    def payment_success_url
      Rails.application.routes.url_helpers.payment_success_membership_url(@membership, host: Rails.application.config.action_mailer.default_url_options[:host])
    end
end
  