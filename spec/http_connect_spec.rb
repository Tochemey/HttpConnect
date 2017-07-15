require 'spec_helper'
require 'http_connect'

# please use your api keys in case you want to run these test.
# for more information check https://developers.hubtel.com/
CLIENT_ID = 'ojwhlgzd'.freeze   
CLIENT_SECRET = 'vyqizpgz'.freeze
BASE_URL = 'https://api.hubtel.com/v1'.freeze

RSpec.describe HttpConnect do
  it 'has a version number' do
    expect(HttpConnect::VERSION).not_to be nil
  end

  it 'post an http request successfully' do
    path = '/messages/'
    content = { 'From' => 'me',
                'To' => '+233244164819',
                'Content' => 'Hello Test Ruby http connect',
                'RegisteredDelivery' => true }

    rest_client = HttpConnect::BasicRestClient.new(BASE_URL)
    rest_client.set_basic_auth(CLIENT_ID, CLIENT_SECRET)
    rest_client.use_ssl = true

    response = rest_client.post(path,
                                'application/x-www-form-urlencoded',
                                'application/json', content)

    expect(response.status_code).to eq(201)
    expect(response.body['Status'].to_i).to eq(0)
  end

  it 'get the content of a resource successfully' do
    path = '/account/profile/'

    rest_client = HttpConnect::BasicRestClient.new(BASE_URL)
    rest_client.set_basic_auth(CLIENT_ID, CLIENT_SECRET)
    rest_client.use_ssl = true

    response = rest_client.get(path, 'application/json')
    expect(response.status_code).to eq(200)

    expect(JSON.parse(response.body)['EmailAddress']).to eq('arsene@smsgh.com')
  end

  it 'update the content of a resource successfully' do
    path = 'account/settings/'

    rest_client = HttpConnect::BasicRestClient.new(BASE_URL)
    rest_client.set_basic_auth(CLIENT_ID, CLIENT_SECRET)
    rest_client.use_ssl = true

    response = rest_client.get(path, 'application/json')
    expect(response.status_code).to eq(200)

    expect(JSON.parse(response.body)['SmsPromotionalMessages']).to eq(false)

    # Let us update the SmsPromotionalMessages
    content = { 'SmsPromotionalMessages' => true }

    response = rest_client.put(path,
                               'application/json',
                               'application/json', content)

    expect(response.status_code).to eq(200)
    expect(JSON.parse(response.body)['SmsPromotionalMessages']).to eq(true)
  end
end
