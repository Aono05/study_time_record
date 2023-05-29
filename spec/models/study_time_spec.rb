require 'rails_helper'

RSpec.describe StudyTime, type: :model do
  describe "#duration" do
    let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
    let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 1, 0) }
    let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }

    it "calculates the duration correctly in minutes" do
      expect(study_time.duration).to eq(1)
    end
  end
end
