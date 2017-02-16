FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :user2, class: User do
    username "Mikko"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, class: Brewery do
    name "Koff"
    year 1900
  end

  factory :style do
    name "Lager"
    description "asd"
  end

  factory :style2, class: Style do
    name "Ipa"
    description "asd"
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer2, class: Beer do
    name "anonymous"
    brewery
    style
  end

end