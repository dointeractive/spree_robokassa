module SpreeRobokassa
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_robokassa'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree_robokassa.payment_method', after: 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods << Spree::BillingIntegration::Robokassa
    end

    initializer 'spree_robokassa.action_view_helpers' do
      ActionView::Base.include ActiveMerchant::Billing::Integrations::ActionViewHelper
    end
  end
end
