class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username] # haetaan usernamea vastaava käyttäjä tietokannasta

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end

  end

  def destroy
    session[:user_id] = nil # nollataan sessio
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end