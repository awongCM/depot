class Notifier < ActionMailer::Base
  default from: "Sam Ruby <depot@example.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.error_occured.subject
  #
  def error_occured(error)
    @error = error

    mail to: "andy@example.com", :subject => 'Depot Mail Error Encountered'
  end
end
