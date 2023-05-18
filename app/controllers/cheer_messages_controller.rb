class CheerMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @random_cheer_message = CheerMessage.random_content
  end
end
