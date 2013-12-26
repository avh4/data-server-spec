require 'spec_helper'
require 'open-uri'

describe 'data server' do
  let(:app_id) { "SPEC: #{unique_id}" }
  let(:user_id) { "SPEC-USER: #{unique_id}" }

  it 'should start with no data' do
    last = 0
    get "/apps/#{app_id}?last=#{last}", { 'X-User-ID' => user_id }
    response.code.should == 200
    json_response.should == []
  end

  describe 'adding transactions' do
    it 'should create the new transactions' do
      pairs = [["k1", "v1"]]
      post_json "/apps/#{app_id}", pairs, { 'X-User-ID' => user_id }
      response.code.should == 202

      last = 0
      get "/apps/#{app_id}?last=#{last}", { 'X-User-ID' => user_id }
      response.code.should == 200
      json_response.should be_transactions [["k1", "v1"]]
    end
  end

  describe 'get' do
    it 'only shows transactions for the authenticated user' do
      pairs = [["key", "user"]]
      post_json "/apps/#{app_id}", pairs, { 'X-User-ID' => user_id }
      response.code.should == 202

      pairs = [["key", "other user"]]
      post_json "/apps/#{app_id}", pairs, { 'X-User-ID' => 'other user' }
      response.code.should == 202

      last = 0
      get "/apps/#{app_id}?last=#{last}", { 'X-User-ID' => user_id }
      response.code.should == 200
      json_response.should be_transactions [["key", "user"]]
    end
  end
end
