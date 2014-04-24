module Spree
  class BillingIntegration::Robokassa < BillingIntegration
    preference :mrch_login, :string
    preference :password1, :string
    preference :password2, :string

    def provider_class
      ActiveMerchant::Billing::Integrations::Robokassa
    end

    def service_url
      /production/ =~ environment ?
        ActiveMerchant::Billing::Integrations::Robokassa.production_url :
        ActiveMerchant::Billing::Integrations::Robokassa.test_url
    end

    def service_request(id, amount)
      helper = ActiveMerchant::Billing::Integrations::Robokassa.helper(
        id,
        preferred_mrch_login,
        secret: preferred_password1,
        amount: amount)

      query = helper.form_fields.map{ |k,v| "#{k}=#{v}" }.reduce{ |a,v| "#{a}&#{v}" }
      "#{service_url}?#{query}"
    end

    def source_required?
      false
    end
  end
end
