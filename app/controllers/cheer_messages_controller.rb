class CheerMessagesController < ApplicationController
  before_action :authenticate_user!

  def show
    #もしオリジナルの応援メッセージがある場合、それを表示。ない場合は、ランダムメッセージを表示する。
    @random_cheer_message = CheerMessage.random_content
  end

  def index
    @cheer_messages = current_user.cheer_messages
  end
end
