mascot_quotes_path = File.expand_path('config/mascot_quotes.json', Rails.root)
mascot_quotes = begin
  File.open(mascot_quotes_path) { |f| JSON.load f }
rescue Exception => e
  puts "WARNING: #{mascot_quotes_path} couldn't be loaded due to #{e.class.name} #{e.message}"
  puts "Using default quotes."

  ["HELLO HUMANS"]
end

Rails.application.mascot_quotes = mascot_quotes