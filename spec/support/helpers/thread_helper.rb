def thread_gen thread = Event.random.thread, comments = 10

  comments.times do
    thread.comments.create creator: User.random, body: Faker::Lorem.sentence
  end

end
