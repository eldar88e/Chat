unless Rails.env == 'test'
  names = %w[John Jack Bob]
  names.each { |name| User.create(email: "#{name.downcase}@gmail.com", password: 123456, name: name) }

  User.first.rooms.create(name: 'Room one')
  User.second.rooms.create(name: 'All users')

  User.first.memberships.create(room_id: 2)
  User.last.memberships.create(room_id: 2)

  puts 'Table is populated!'
end
