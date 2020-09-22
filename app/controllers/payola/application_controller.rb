module Payola
  class ApplicationController < ::ApplicationController
    helper PriceHelper

    private

    def return_to
      return params[:return_to] if params[:return_to]

      request.headers['Referer'] or raise ActionController::RoutingError, "Cannot redirect. Referer header is missing."
    end
  end
end
