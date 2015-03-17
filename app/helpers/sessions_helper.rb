module SessionsHelper

  def sign_in(user)
    #во-первых, создаем новый токен;
    remember_token = User.new_remember_token
    #во-вторых, помещаем зашифрованный токен в куки браузера
    cookies.permanent[:remember_token] = remember_token
    #в-третьих, сохраняем зашифрованный токен в базе данных;
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    #в-четвертых, устанавливаем текущего пользователя равным данному пользователю
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
