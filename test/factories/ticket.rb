Factory.define(:ticket) do |t|
  t.creator { Factory(:user) }
  t.summary "New Ticket"
  t.description "New Ticket"
  t.readiness 2
  t.importance 2
  t.state 'submitted'
end
