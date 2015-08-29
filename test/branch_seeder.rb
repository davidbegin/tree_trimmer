require "faker"

10.times do
  words = Faker::Lorem.words.join("-")
  system("git checkout -b #{words}")
end

system("git checkout master")
