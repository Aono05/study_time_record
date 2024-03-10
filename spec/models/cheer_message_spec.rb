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

  describe '#random' do
    let(:cheer_message) { described_class.new }
    let(:output) { described_class.random(input) }

    context 'オリジナルの応援メッセージがある時' do
      let(:random_messages) { ["messageA", "messageB", "messageC"] }
      let(:input) { random_messages }
      let(:expected) { random_messages }

      it 'オリジナルの応援メッセージリストから応援メッセージがランダムで返ってくる' do
        expect(expected).to include(output)
      end
    end

    context 'オリジナルの応援メッセージがない時' do
      let(:input) { [] }
      let(:expected) { described_class::CHEER_MESSAGES }

      it 'デフォルトの応援メッセージリストから応援メッセージがランダムで返ってくる' do
        expect(expected).to include(output.content)
      end
    end
  end
end
