class UserSeeder
  def self.fake_name
    Faker::Name.name.split(' ')
  end

  def self.fake_email
    randomize_array = ('a'..'z').to_a + ('0'..'9').to_a
    email = Faker::Internet.email.match(/(.+)(@.+)/).to_a
    email[1] += randomize_array.sample(9).join('')
    email
  end

  def self.f_phot
    dog_or_cat = ["dog", "cat"]
    "#{dog_or_cat.sample}#{rand(9) + 1}.jpeg"
  end
end
