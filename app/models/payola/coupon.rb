module Payola
  class Coupon < ActiveRecord::Base
    validates :code, uniqueness: true
  end
end
