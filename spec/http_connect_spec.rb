require 'spec_helper'
require 'http_connect'

RSpec.describe HttpConnect do
  it 'has a version number' do
    expect(HttpConnect::VERSION).not_to be nil
  end

  it 'post an http request successfully' do
    base_url = 'https://api.hubtel.com/v1'
    path = '/messages/'
    client_id = 'ojwhlgzd'
    client_secret = 'vyqizpgz'
    content = { 'From' => 'me',
                'To' => '+233247063817',
                'Content' => 'Hello Test Ruby http connect',
                'RegisteredDelivery' => true }

    rest_client = HttpConnect::BasicRestClient.new(base_url)
    rest_client.set_basic_auth(client_id, client_secret)
    rest_client.use_ssl = true

    response = rest_client.post(path,
                                'application/x-www-form-urlencoded',
                                'application/json', content)

    expect(response.status_code).to eq(201)
    expect(response.body['Status'].to_i).to eq(0)
  end

  it 'get the content of a resource successfully' do
    base_url = 'https://api.hubtel.com/v1'
    path = '/account/profile/'
    client_id = 'ojwhlgzd'
    client_secret = 'vyqizpgz'

    rest_client = HttpConnect::BasicRestClient.new(base_url)
    rest_client.set_basic_auth(client_id, client_secret)
    rest_client.use_ssl = true

    response = rest_client.get(path, 'application/json')
    expect(response.status_code).to eq(200)

    expect(JSON.parse(response.body)['EmailAddress']).to eq('arsene@smsgh.com')
  end
end
