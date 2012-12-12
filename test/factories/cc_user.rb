Factory.define :cc_user do |u|
  u.user { Factory(:user) }
  u.ticket { Factory(:ticket) }
end
