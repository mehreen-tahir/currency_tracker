FactoryBot.define do
  factory :history do
    bid { 13360.00000000 }
    ask { 13370.00000000 }
    last { 13370.00000000 }
    currency { :btc }
    time { "2020-03-01T16:21:31.481732Z" }
  end
end
