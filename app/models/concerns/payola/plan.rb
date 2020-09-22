require 'active_support/concern'

module Payola
  module Plan
    extend ActiveSupport::Concern

    included do
      validates :amount, presence: true
      validates :interval, presence: true
      validates :stripe_id, presence: true
      validates :name, presence: true

      validates :stripe_id, uniqueness: true

      before_create :create_stripe_plan, if: -> { Payola.create_stripe_plans }

      has_many :subscriptions, class_name: 'Payola::Subscription', as: :plan,
                               dependent: :restrict_with_exception

      Payola.register_subscribable(self)
    end

    def create_stripe_plan
      Payola::CreatePlan.call(self)
    end

    def plan_class
      self.class.plan_class
    end

    def product_class
      plan_class
    end

    def price
      amount
    end

    module ClassMethods
      def subscribable?
        true
      end

      def plan_class
        to_s.underscore.parameterize
      end
    end
  end
end
