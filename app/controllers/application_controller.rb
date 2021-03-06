class ApplicationController < ActionController::Base
  protect_from_forgery


  def after_sign_up_path_for(resource)
     new_profiles_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

end
