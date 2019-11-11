module Payola
  module AffiliateBehavior
    extend ActiveSupport::Concern

    included do
      before_action :find_affiliate
    end

    def find_affiliate
      affiliate_code = cookies[:aff] || params[:aff]
      @affiliate = Payola::Affiliate.where('lower(code) = lower(?)', affiliate_code).first
      cookies[:aff] = affiliate_code if @affiliate
    end
  end
end
