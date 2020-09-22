module Payola
  class Affiliate < ActiveRecord::Base
    validates :code, uniqueness: true
  end
end
