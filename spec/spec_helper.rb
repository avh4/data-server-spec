require 'socket'
require 'etc'
require 'httparty'

def unique_id
  "#{Etc.getlogin}@#{Socket.gethostname} #{Time.now}"
end

SERVER_URL = ENV['SERVER_URL'] or raise '$SERVER_URL not specified'

module HttpUtils
  def from(last)
    get "/apps/#{app_id}/from/#{last}"
    response.code.should == 200
    json_response
  end

  def add(*pairs)
    post_json "/apps/#{app_id}", pairs
    response.code.should == 202
  end

  def url(path)
    URI::encode "#{SERVER_URL}#{path}"
  end

  def get(path)
    @response = HTTParty.get(url(path))
  end

  def post_json(path, json)
    @response = HTTParty.post(url(path),
          body: json.to_json,
          headers: { 'Content-Type' => 'application/json'})
  end

  def response
    @response
  end

  def json_response
    response.parsed_response
  end
end

RSpec::Matchers.define :be_transactions do |expected|
  match do |actual|
    actual_copy = actual.dup
    ok = true
    ok = false if actual.length != expected.length
    last_id = 0
    expected.each do |ek, ev|
      id, ak, av = actual_copy.shift
      ok = false unless [ak, av] == [ek, ev]
      ok = false unless id > last_id
      last_id = id
    end
    ok
  end
end

RSpec.configure do |config|
  config.include(HttpUtils)
end