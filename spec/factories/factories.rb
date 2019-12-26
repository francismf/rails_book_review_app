FactoryBot.define do
  factory :user do
    # sequence(:email) { |n| "test-#{n.to_s.rjust(3, "0")}@santa.com" }
    email {"test12" + random_string + "@santa.com"}
    password { "test1234" }
  end

end
  def random_string
  ('a'..'z').to_a.shuffle.join
  end

