module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def current_user_cookie
    if user_id = cookies["user_id"]
      user= User.find_by(id: user_id)
      if user && user.authenticated?(cookies["remember_token"])
        log_in user
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  def cookie
    ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def remember_me(user)
    user.remember
    cookie.permanent.signed[:user_id] = user.id
    cookies["user_id"] = cookie.permanent.signed[:user_id]
    cookie.permanent[:remember_token] = user.remember_token
    cookies["remember_token"] = cookie.permanent[:remember_token]
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def currect_user?(user)
    user == current_user
  end
  
end
