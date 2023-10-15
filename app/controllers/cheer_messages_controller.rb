class CheerMessagesController < ApplicationController
  before_action :authenticate_user!

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
    @cheer_message = persisted_cheer_message

    if @cheer_message.present?
      render :show
    else
      redirect_to cheer_messages_path, notice: '指定された応援メッセージが見つかりません'
    end
  end

  def edit
    @cheer_message = persisted_cheer_message
  end

  def update
    @cheer_message = persisted_cheer_message

    if @cheer_message.update!(cheer_message_params)
      redirect_to @cheer_message
    else
      render 'edit'
    end
  rescue StandardError => e
    redirect_to cheer_messages_path, notice: '応援メッセージの更新中にエラーが発生しました'
  end

  def destroy
    persisted_cheer_message&.destroy
    redirect_to cheer_messages_path, notice: '応援メッセージを削除しました'
  end

  private

  def cheer_message_params
    params.require(:cheer_message).permit(:content, :image)
  end

  def persisted_cheer_message
    current_user.cheer_messages.find_by(id: params[:id])
  end
end
