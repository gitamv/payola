require 'active_support/concern'

module Payola
  module Sellable
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true
      validates :permalink, presence: true
      validates :price, presence: true
      validates :permalink, uniqueness: true

      Payola.register_sellable(self)
    end

    def product_class
      self.class.product_class
    end

    module ClassMethods
      def sellable?
        true
      end

      def product_class
        to_s.underscore
      end
    end
  end
end
