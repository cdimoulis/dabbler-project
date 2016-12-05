class Auth::PasswordsController < Clearance::PasswordsController

  # Override Clearance::PasswordsController
  def create
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end
    render template: 'passwords/create'
  end

  # Override Clearance::PasswordsController
  def edit
    @user = find_user_for_edit

    if params[:token]
      session[:password_reset_token] = params[:token]
      redirect_to url_for
    else
      render template: 'passwords/edit'
    end
  end

  # Override Clearance::PasswordsController
  def new
    render template: 'passwords/new'
  end

  # Override Clearance::PasswordsController
  def update
    @user = find_user_for_update

    if @user.update_password password_reset_params
      sign_in @user
      redirect_to url_after_update
      session[:password_reset_token] = nil
    else
      flash_failure_after_update
      render template: 'passwords/edit'
    end
  end

  private

  def deliver_email(user)
    mail = UserMailer.change_password(user)

    if mail.respond_to?(:deliver_later)
      mail.deliver_later
    else
      mail.deliver
    end
  end

  # def flash_failure_when_forbidden
  #   flash.now[:notice] = translate(:forbidden,
  #     scope: [:clearance, :controllers, :passwords],
  #     default: t('flashes.failure_when_forbidden'))
  # end
  #
  # def flash_failure_after_update
  #   flash.now[:notice] = translate(:blank_password,
  #     scope: [:clearance, :controllers, :passwords],
  #     default: t('flashes.failure_after_update'))
  # end
end
