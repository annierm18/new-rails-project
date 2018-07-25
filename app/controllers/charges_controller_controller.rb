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

      def cancel_plan
        @user = current_user
        if @user.cancel_user_plan(params[:customer_id])
          @user.update_attributes(customer_id: nil, plan_id: 1)
          flash[:notice] = "Canceled subscription."
          redirect_to root_path
        else
          flash[:error] = "There was an error canceling your subscription. Please notify us."
          redirect_to edit_user_registration_path
        end
      end

      current_user.update_attributes!(role: 'standard')

end
