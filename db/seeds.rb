require 'faker'

5.times do
  user = User.create(user_name: Faker::Internet.user_name, email: Faker::Internet.email, password_hash: Faker::Internet.password)

    10.times do
      Tweet.create(content: Faker::Company.catch_phrase, user_id: user.id)
    end

end
