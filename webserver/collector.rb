require 'sinatra'

set :bind, '0.0.0.0'

get '/results' do
  file      = File.open('results.txt')
  file_data = file.readlines.map(&:chomp)
  file.close
  output    = "<h2>Results</h2>\n"
  file_data.each do |num|
    output += "<p>#{num}</p>\n"
  end
  return output
end

post '/api' do
  request.body.rewind
  data = request.body.read
  open('results.txt', 'a') { |f| f.puts data }
end
