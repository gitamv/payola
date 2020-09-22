require 'payola/worker/base'
require 'payola/worker/active_job'
require 'payola/worker/sidekiq'
require 'payola/worker/sucker_punch'

module Payola
  module Worker
    class << self
      attr_accessor :registry

      def find(symbol)
        if registry.has_key? symbol
          registry[symbol]
        else
          raise "No such worker type: #{symbol}"
        end
      end

      def autofind
        # prefer ActiveJob over the other workers
        return Payola::Worker::ActiveJob if Payola::Worker::ActiveJob.can_run?

        registry.values.each do |worker|
          return worker if worker.can_run?
        end

        raise 'No eligible background worker systems found.'
      end
    end

    self.registry = {
      sidekiq: Payola::Worker::Sidekiq,
      sucker_punch: Payola::Worker::SuckerPunch,
      active_job: Payola::Worker::ActiveJob
    }
  end
end
