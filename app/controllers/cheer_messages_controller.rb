class CheerMessagesController < ApplicationController
  before_action :authenticate_user!

  def display
    #もしオリジナルの応援メッセージがある場合、それを表示。ない場合は、ランダムメッセージを表示する。
    @random_cheer_message = CheerMessage.random_content
  end

  def index
    @cheer_messages = current_user.cheer_messages
  end

  def new
    @cheer_message = CheerMessage.new
  end

  def create
    @cheer_message = current_user.cheer_messages.build(cheer_message_params)

    if @cheer_message.save
      redirect_to cheer_messages_path
    else
      render 'new'
    end
  end

  def show
    if @cheer_message.present?
      render :show
    else
      redirect_to cheer_messages_path, notice: '指定された応援メッセージが見つかりません'
    end
  end

  private

  def cheer_message_params
    params.require(:cheer_message).permit(:content)
  end
end
