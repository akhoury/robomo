Factory.define(:post) do |p|
  p.creator { Factory(:user) }
  p.ticket { Factory(:ticket) }
  p.body "This is a post"
end
