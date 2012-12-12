Factory.define :user do |u|
  u.sequence(:name) {|n| "User #{n}"}
end

Factory.define(:admin, :parent => :user) do |a|
  a.admin true
end
