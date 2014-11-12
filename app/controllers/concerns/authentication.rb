module Authentication
  extend ActiveSupport::Concern

  def current_user=(user)
    @current_user = user

    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find(user_id)
    else
      nil
    end
  rescue
    forget_current_user
    require_user
  end

  def forget_current_user
    @current_user = nil

    session.delete(:user_id)
  end

  def require_user
    unless current_user
      # TODO: This seems brittle
      if request.fullpath =~ /\.json/
        head :unauthorized
      else
        store_location
        redirect_to '/auth/sign_in'
      end
    end
  end

  def redirect_back_or_default(default = root_path)
    redirect_to(session.delete(:return_to) || default)
  end

  def store_location
    # TODO: This seems brittle
    unless request.fullpath =~ /\.(json|xml)/
      session[:return_to] = request.fullpath
    end
  end
end
