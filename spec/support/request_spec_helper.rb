module RequestSpecHelper

  # Sign in a user, provide the proper password
  def full_sign_in(user, password)
    session = {email: user.email, password: password}
    post '/session', session: session, format: :json
  end

  # Sign out the currently logged in user
  def full_sign_out
    delete '/session'
  end
end
