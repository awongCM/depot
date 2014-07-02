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

end
