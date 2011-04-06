require 'rubygems'
require 'sinatra'
require 'httparty'
require 'crack'

post '/:topic_id' do
  credentials
  payload = { "topic_id" => params[:topic_id], "message" => message }
  options = { :basic_auth => { :username => @username, :password => @password }, :body => payload }
  response = HTTParty.post "https://convore.com/api/topics/#{params[:topic_id]}/messages/create.json", options
  status response.code
end

def credentials
  auth = Rack::Auth::Basic::Request.new(request.env)
  @username = auth.credentials[0]
  @password = auth.credentials[1]
end

def message
  input = Crack::XML.parse(request.body)
  description = input['activity']['description']
  url = input['activity']['stories']['story']['url']
  "#{description} #{url}"
end