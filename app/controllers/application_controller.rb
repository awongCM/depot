class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize
  before_action :set_i18n_locale_from_params

  protected

  def authorize
      unless User.find_by(id: session[:user_id]) || User.count.zero?
        session[:original_uri] = request.env['REQUEST_URI']
        flash[:notice] = "Please log in"
        redirect_to login_url, notice: "Please log in"
      end

      if (User.count.zero?)
        if !(request.path_parameters[:controller] == 'users' and request.path_parameters[:action] == 'new')
          if !(request.path_parameters[:controller] == 'users' and request.path_parameters[:action] == 'create')
              redirect_to(:controller=>'admin', :action=>'login')
          end
        end
      end
  end

  def set_i18n_locale_from_params
      if params[:locale]
          if I18n.available_locales.map(&:to_s).include?(params[:locale])
              I18n.locale = params[:locale]
          else
              flash.now[:notice] =
                "#{params[:locale]} translation not available"
              logger.error flash.now[:notice]
          end
      end
  end

  def default_url_options
      { locale: I18n.locale }
  end

end
