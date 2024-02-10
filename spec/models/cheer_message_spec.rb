require 'rails_helper'

RSpec.describe CheerMessage, type: :model do
  let(:cheer_message) { described_class.new }

  describe '#valid_image' do
    context 'オリジナルの応援画像がある時' do
      it 'オリジナルの応援画像のURLが返ってくる' do
        image_mock = double('image', present?: true, url: 'original_image_url')
        allow(cheer_message).to receive(:image).and_return(image_mock)

        expect(cheer_message.valid_image).to eq('original_image_url')
      end
    end

    context 'オリジナル応援画像がない時' do
      it 'デフォルト応援画像のURLが返ってくる' do
        image_double = double('image', present?: false)
        allow(cheer_message).to receive(:image).and_return(image_double)

        expect(cheer_message.valid_image).to eq("/assets/#{CheerMessage::DEFAULT_IMAGE_NAME}")
      end
    end
  end

  describe '#uploaded_image_status' do
    context '応援画像がある時' do
      it '"画像あり"が返ってくる' do
        image_double = double('image', present?: true)
        allow(cheer_message).to receive(:image).and_return(image_double)

        expect(cheer_message.uploaded_image_status).to eq('画像あり')
      end
    end

    context '応援画像がない時' do
      it '"画像なし"が返ってくる' do
        image_double = double('image', present?: false)
        allow(cheer_message).to receive(:image).and_return(image_double)

        expect(cheer_message.uploaded_image_status).to eq('画像なし')
      end
    end
  end

  describe '.random' do
    context 'オリジナルの応援メッセージがある時' do
      let(:cheer_messages) { ['message1', 'message2', 'message3'] }

      it 'オリジナルの応援メッセージリストから応援メッセージがランダムで返ってくる' do
        expect(cheer_messages).to include(CheerMessage.random(cheer_messages))
      end
    end

    context 'オリジナルの応援メッセージがない時' do
      let(:empty_cheer_messages) { [] }

      it 'デフォルトの応援メッセージリストから応援メッセージがランダムで返ってくる' do
        expect(CheerMessage.random(empty_cheer_messages)).to be_a(CheerMessage)
      end
    end
  end
end
