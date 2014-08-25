class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize

  protected

  def authorize
      unless User.find_by(id: session[:user_id]) || User.count.zero?
        session[:original_uri] = request.request_uri
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

end
