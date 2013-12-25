require 'spec_helper'
require 'open-uri'

describe 'data server' do
  let(:app_id) { "SPEC: #{unique_id}"}
  
  it 'should start with no data' do
    from(0).should == []
  end
  
  describe 'adding transactions' do
    it 'should create the new transactions' do
      add ["k1", "v1"]
      from(0).should be_transactions [["k1", "v1"]]
    end
  end
end