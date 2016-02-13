class SessionController < ApplicationController
  def index
    @login_link = Client.authenticate_url
  end

  def callback
    puts params
  end
end
