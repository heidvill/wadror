class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username] # haetaan usernamea vastaava käyttäjä tietokannasta

    if user && user.authenticate(params[:password])
      redirect_to :back, notice: "Your account is frozen, please contact admin" and return if user.suspended?

      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

end