# app/services/flutterwave_payment_service.rb
class FlutterwavePaymentService
    def initialize(booking)
      @booking = booking
      @venue = booking.venue
      @api_key = "FLWSECK_TEST-5888bc2d2331e6137f56fb83be4484f7-X" # Replace with your actual secret key
    end
  
    def initiate_payment
      payment_data = {
        tx_ref: SecureRandom.hex(10), # Unique transaction reference
        amount: @venue.price, # Use the venue's price as the amount
        currency: 'GHS',
        redirect_url: payment_success_url,
        payment_options: 'card, mobilemoneyghana',
        customer: {
          email: @booking.user.email,
          phonenumber: @booking.user.phone, # Assuming user model has a phone attribute
          name: @booking.user.full_name # Assuming user model has a full_name method
        },
        customizations: {
          title: 'Venue Booking Payment',
          description: "Payment for booking at #{@venue.name}",
          logo: 'https://flcms-99e59f7f5d8a.herokuapp.com/assets/logo-img-1-5be75ec22e5c2c62cb5e1d2161924c07fae0db0619b6c635d0d0d40b04d5b05c.png' # Replace with your logo URL
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
      Rails.application.routes.url_helpers.payment_success_booking_url(@booking, host: Rails.application.config.action_mailer.default_url_options[:host])
    end
  end
  