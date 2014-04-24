module Spree
  CheckoutController.class_eval do
    private

    alias_method :old_completion_route, :completion_route

    def completion_route
      if pending_robokassa_payment.present?
        pending_robokassa_payment.pend
        robokassa_route
      else
        old_completion_route
      end
    end

    def pending_robokassa_payment
      @robokassa_payment ||= @order.pending_payments.detect do |p|
        p.payment_method.is_a? BillingIntegration::Robokassa
      end
    end

    def robokassa_route
      pending_robokassa_payment.payment_method.service_request(@order.id, @order.total)
    end
  end
end
