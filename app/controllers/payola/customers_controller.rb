module Payola
  class CustomersController < ApplicationController
    before_action :check_modify_permissions, only: [:update]

    def update
      if params[:id].present?
        Payola::UpdateCustomer.call(params[:id], customer_params)
        flash_options = { notice: t('payola.customers.updated') }
      else
        flash_options = { alert: t('payola.customers.not_updated') }
      end
      redirect_to return_to, flash: flash_options
    end

    private

    # Only including default_source for now, though other attributes can be used
    # (https://stripe.com/docs/api#update_customer)
    def customer_params
      params.require(:customer).permit(:default_source)
    end

    def check_modify_permissions
      if respond_to?(:payola_can_modify_customer?)
        unless payola_can_modify_customer?(params[:id])
          redirect_to(
            return_to,
            alert: t('payola.customers.not_authorized')
          ) and return
        end
      else
        raise NotImplementedError.new('Please implement ApplicationController#payola_can_modify_customer?')
      end
    end
  end
end
