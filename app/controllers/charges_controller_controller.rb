class ChargesControllerController < ApplicationController



  def new
    @stripe_btn_data = {
    key: "#{ Rails.configuration.stripe[:publishable_key] }",
    description: "BigMoney Membership - #{current_user.name}",
    amount: Amount.default
  }
  end

  def create
      @amount = 15

      @amount = @amount.gsub('$', '').gsub(',', '')

      begin
        @amount = Float(@amount).round(2)
      rescue
        flash[:error] = 'Charge not completed. Please enter a valid amount in USD ($).'
        redirect_to new_charge_path
        return
      end

      @amount = (@amount * 100).to_i # Must be an integer!

      if @amount < 1500 || @amount > 1500
        flash[:error] = 'Charge not completed. Donation amount must be $15.'
        redirect_to new_charge_path
        return
      end

      customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: Amount.default,
        description: "BigMoney Membership - #{current_user.email}",
        currency: 'usd'
      )

      flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
      redirect_to user_path(current_user)

      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
      end
  
end
