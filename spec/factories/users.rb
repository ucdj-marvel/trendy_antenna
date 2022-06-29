FactoryBot.define do
  factory :user do
    username {"test"}
    email {"test@gmail.com"}
    password {"passpass"}
    password_confirmation {"passpass"}
  end
end
