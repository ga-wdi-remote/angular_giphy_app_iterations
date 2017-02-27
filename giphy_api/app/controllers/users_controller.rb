class UsersController < ApplicationController
  before_action :authenticate, except: [:login, :create]
  before_action :authorize, except: [:login, :create]

  def create
    user = User.new(user_params)
    if user.save
      render json: {status: 200, message: "ok"}
    else
      render json: {status: 422, user: user.errors}
    end
  end

  def show
    user = current_user
    render json: {status: 200, user: user}
  end

  def login
    user = User.find_by(email: params[:user][:email])

    if user && user.authenticate(params[:user][:password])

      token = token(user.id, user.email)

      render json: { status: 201, token: token, user: user }
    else
      render json: { status: 401, message: "unauthorized" }
    end
  end

  private

  def token(id, email)
    JWT.encode(payload(id, email), 'someawesomesecret', 'HS256')
  end

  def payload(id, email)
    {
      exp: (Time.now + 5.minutes).to_i,
      iat: Time.now.to_i,
      iss: 'wdir-matey',
      user: {
        id: id,
        email: email
      }
    }
  end

  def user_params
    params.required(:user).permit(:email, :password)
  end

end
