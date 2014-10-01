module ApplicationHelper

    def date_today
        I18n.l Time.now, format: :short
    end

    def hidden_div_if(condition, attributes={}, &block)
      if condition
        attributes["style"] = "display:none;"
      end
      content_tag("div", attributes, &block)
    end

    #Currency Conversion Helper method
    def currency_to_locale(price)
        price = price * 1.3 if 'es' == I18n.locale.to_s
        number_to_currency(price, precision: 2)
    end

end
