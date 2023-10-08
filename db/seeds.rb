# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

raise if !Rails.env.development?

User.delete_all
StudyTime.delete_all

USER_COUNT = 5
STUDY_TIME_COUNT = 10

now = Time.now

USER_COUNT.times do |n|
  User.create(
    email: "test#{n}@example.com",
    password: 'hoge1234567890@',
    name: "test_user#{n}",
    introduction: "test_user#{n}です。"
  )
end

user_ids = User.all.ids

user_ids.each do |user_id|
  STUDY_TIME_COUNT.times do |n|
    StudyTime.create(
      user_id: user_id,
      started_at: now - n.days,
      ended_at: now + 1.hour - n.days,
      created_at: now + 1.hour - n.days,
      updated_at: now + 1.hour - n.days
    )
  end
end
