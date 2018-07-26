class ChargesControllerController < ApplicationController
skip_after_action :verify_policy_scoped, :only => :index


  def new
    amount = 15.00
    @stripe_btn_data = {
    key: "#{ Rails.configuration.stripe[:publishable_key] }",
    description: "BigMoney Membership - #{current_user.email}",
    amount: @amount
  }
  end

  def create
      customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripeToken],
        name: current_user.name
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: 15.00,
        description: "Premium Membership - #{current_user.email}",
        currency: 'usd'
      )

      current_user.update_attributes!(role: 'premium')

      flash[:notice] = "Thanks for upgrading to a Premium Membership, #{current_user.email}! Feel free to pay me again."
      redirect_to user_path(current_user)

      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
      end



end
