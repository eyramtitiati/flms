class Admin::DashboardController < Admin::BaseController
  layout 'admin'

  layout 'admin'

  def index
    @total_registrations = Membership.count
    @pending_registrations = Membership.where(status: 'Pending').count
    @confirmed_registrations = Membership.where(status: 'Confirmed').count
  end
end
