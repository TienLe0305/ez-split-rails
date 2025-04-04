# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create default users
users = [
  { name: 'Phương', bank_account: '123456789', bank_name: 'VPBank' },
  { name: 'Thắng', bank_account: '234567890', bank_name: 'VPBank' },
  { name: 'Hoàng', bank_account: '345678901', bank_name: 'VPBank' },
  { name: 'Giang', bank_account: '456789012', bank_name: 'VPBank' },
  { name: 'Đức', bank_account: '567890123', bank_name: 'VPBank' },
  { name: 'Duyệt', bank_account: '678901234', bank_name: 'VPBank' },
  { name: 'Tâm', bank_account: '789012345', bank_name: 'VPBank' }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end

puts "Created #{User.count} users"
