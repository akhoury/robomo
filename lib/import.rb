def random_user(user = nil)
  until user
    user = User.where("users.id in (select id from users where random() < 0.4)").first
  end
  user
end

idea_lines = <<-EOF
Write a note of appreciation to your mailman
Compliment a stranger sincerely
Write a thank you note to someone
Give a lottery ticket to a stranger
Badges
Search improvements on the site
Public user pages
New navigation
User wiki
10 easy usability fixes
Admin fixes
Improve password strength checker
Walled garden
REST APIs
As a user I would like to see a count of groups in the group list, and what the current maximum is
Indicate ability to build
Include ability to format chat/IM's
As a User, I want to be able to do simple math in numeric edit fields
Track how users interact with mass emails
Disclaimer updates
Followup thank you message for surveys
Video guides
Simplify & unify redirects
User feedback repository
EOF

ideas = idea_lines.split("\n").select(&:present?)

ideas.each do |i|
  Ticket.create!(:summary => i, :description => i, :creator => random_user, :state => Ticket.states.sample)
end
