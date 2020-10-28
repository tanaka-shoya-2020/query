User.create!(nickname: "test1",
        email: "foobar1@gmail.com",
        password: "foobar1",
        password_confirmation: "foobar1")

User.create!(nickname: "test2",
        email: "foobar2@gmail.com",
        password: "foobar1",
        password_confirmation: "foobar1")

User.create!(nickname: "test3",
        email: "foobar3@gmail.com",
        password: "foobar1",
        password_confirmation: "foobar1")

Room.create!(name: "test1",
        password: "foobar1",
        password_confirmation: "foobar1")

Room.create!(name: "test2",
        password: "foobar1",
        password_confirmation: "foobar1")

30.times do |n|
  title = 'a' * 20
  text = 'a'* 50
  Article.create!(title: title,
              text: text,
              user_id: 1,
              room_id: 1)
end

30.times do |n|
  title = 'a' * 20
  text = 'a'* 50
  Article.create!(title: title,
              text: text,
              user_id: 2,
              room_id: 1)
end

30.times do |n|
  title = 'a' * 20
  text = 'a'* 50
  Article.create!(title: title,
              text: text,
              user_id: 3,
              room_id: 2)
end

30.times do |n|
  comment = 'テスト' * 10
  Comment.create!(comment: comment,
              user_id: 2,
              room_id: 1,
              article_id: 1)
end

