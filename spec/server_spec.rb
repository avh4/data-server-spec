require 'spec_helper'
require 'open-uri'

describe 'data server' do
  let(:app_id) { "SPEC: #{unique_id}"}
  
  it 'should start with no data' do
    get "/apps/#{app_id}/from/0"
    response.code.should == 200
    json_response.should == []
  end
  
  describe 'adding transactions' do
    it 'should create the new transactions' do
      post_json "/apps/#{app_id}", [["k1", "v1"]]
      response.code.should == 202

      get "/apps/#{app_id}/from/0"
      response.code.should == 200
      json_response.should be_transactions [["k1", "v1"]]
    end
  end
end