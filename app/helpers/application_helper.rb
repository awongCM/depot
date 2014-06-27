module ApplicationHelper

    def date_today
        I18n.l Time.now, format: :short
    end
end
