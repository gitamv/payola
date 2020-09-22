require 'active_support/concern'

module Payola
  module GuidBehavior
    extend ActiveSupport::Concern

    included do
      before_save :populate_guid
      validates :guid, uniqueness: true
    end

    def populate_guid
      self.guid = Payola.guid_generator.call while !valid? || guid.nil? if new_record?
    end
  end
end
