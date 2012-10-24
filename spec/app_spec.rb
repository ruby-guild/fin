require_relative '../app'
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'Fin application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'responds ok' do
    get '/'
    last_response.should be_ok
  end

  it 'shows form' do
    get '/'
    last_response.body.should include("<form action=''")
  end

  it 'shows inputs for adding' do
    get '/'
    last_response.body.should include("title")
    last_response.body.should include("price")
  end

end
