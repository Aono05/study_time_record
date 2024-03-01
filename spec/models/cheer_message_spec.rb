require 'rails_helper'

RSpec.describe CheerMessage, type: :model do
  describe '#valid_image_path' do
    context 'オリジナルの応援画像がある時' do
      let(:cheer_message) { described_class.new(image: fixture_file_upload('image.png', 'image/png')) }
      let(:expected) { cheer_message.image.url }

      it 'オリジナルの応援画像のpathが返ってくる' do
        expect(cheer_message.valid_image_path).to eq(expected)
      end
    end

    context 'オリジナル応援画像がない時' do
      let(:cheer_message) { described_class.new }
      let(:expected) {"/assets/default.png"}

      it 'デフォルト応援画像のpathが返ってくる' do
        cheer_message = described_class.new
        expect(cheer_message.valid_image_path).to eq(expected)
      end
    end
  end

  describe '.random' do
    context 'オリジナルの応援メッセージがある時' do
      let(:cheer_messages) { ['message1', 'message2', 'message3'] }
      let(:expected) {described_class.random(cheer_messages)}

      it 'オリジナルの応援メッセージリストから応援メッセージがランダムで返ってくる' do
        expect(cheer_messages).to include(expected)
      end
    end

    context 'オリジナルの応援メッセージがない時' do
      let(:empty_cheer_messages) { [] }

      it 'デフォルトの応援メッセージリストから応援メッセージがランダムで返ってくる' do
        allow(YAML).to receive(:load_file).with("config/cheer_messages.yml").and_return([])
        allow(CheerMessage::CHEER_MESSAGES).to receive(:sample).and_return("ファイト")
        random_message = described_class.random([])
        expect(random_message.content).to eq("ファイト")
      end
    end
  end
end
