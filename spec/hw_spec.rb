# spec/hw_spec.rb
require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "expect accessing the home page to be successful" do
    get '/'
    expect(last_response).to be_ok
  end
end
