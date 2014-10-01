module OrdersHelper

    #Helper method for payment types Internationalization
    def payment_type_options
        options_for_select(Hash[PaymentType.payment_types_a.map { |x| [I18n.t('orders.payment_types.' + x.name.parameterize.underscore), x.id] }])
    end

end
