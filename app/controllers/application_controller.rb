class ApplicationController < ActionController::Base
  protected

  def set_alert(message)
    flash.now[:danger] = message
  end
end
