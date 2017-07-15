require 'http_connect/version'
require 'Base64'
require 'http_connect/http_post'
require 'http_connect/http_get'
require 'http_connect/http_put'
require 'http_connect/http_request'
require 'http_connect/http_response'
require 'http_connect/http_delete'
require 'net/http'
require 'pry'
require 'json'

# HttpConnect module
module HttpConnect
  # constants definition
  DEFAULT_ACCEPT = 'application/json'.freeze
  DEFAULT_CONTENT_TYPE = 'application/json'.freeze
  FORM_DATA = 'application/x-www-form-urlencoded'.freeze

  #  BasicRestClient
  class BasicRestClient
    attr_reader :base_url # base url of the http request
    attr_accessor :custom_headers # custom http headers to add to the request
    attr_accessor :read_write_timeout # read and write http request timeout
    attr_accessor :connection_timeout # connection timeout
    attr_accessor :use_ssl # helps to set the request scheme to https

    # initialize()
    def initialize(base_url)
      @base_url = base_url
      @custom_headers = {}
      @read_write_timeout = 8000
      @connection_timeout = 2000
      @use_ssl = false
    end

    # set_basic_auth()
    # @param username the username credential
    # @param password the password credential
    def set_basic_auth(username, password)
      @custom_headers['Authorization'] =
        "Basic #{Base64.encode64(username + ':' + password)}".chomp
    end

    # execute(). It helps execute an Http request
    # one can use the following object:
    #     - HttpPost
    #     - HttpGet
    #     - HttpDelete
    #     - HttpPut
    # @param http_webrequest the HttpRequest object
    # @return HttpResponse object or an Http Error object
    def execute(http_webrequest)
      raise ArgumentError, 'http_webrequest is not a subclass of HttpRequest' 
          unless http_webrequest.is_a? HttpRequest
      do_http_request(http_webrequest.path,
                      http_webrequest.http_method,
                      http_webrequest.content_type,
                      http_webrequest.accept, http_webrequest.content)
    end

    # post(). It helps send an HTTP POST request
    # to create the specified resource
    # @param path the resource path
    # @param content_type the http request content type
    # @param accept the expected mime type of the response
    # @param content the http request payload
    def post(path, content_type, accept, content = {})
      execute HttpConnect::HttpPost.new(path, content_type, accept, content)
    end

    # put(). It helps send an HTTP PUT request
    # to create or modified the specified resource
    # @param path the resource path
    # @param content_type the http request content type
    # @param accept the expected mime type of the response
    # @param content the http request payload
    def put(path, content_type, accept, content = {})
      execute HttpConnect::HttpPut.new(path, content_type, accept, content)
    end

    # get(). It helps send an HTTP GET request
    # to fetch the specified resource
    # @param path the resource path
    # @param content_type the http request content type
    # @param accept the expected mime type of the response
    # @param content the http request payload
    def get(path, accept, content = {})
      execute HttpConnect::HttpGet.new(path, nil, accept, content)
    end

    # delete(). It helps send an HTTP DELETE request
    # to delete the specified resource
    # @param path the resource path
    # @param content_type the http request content type
    # @param accept the expected mime type of the response
    # @param content the http request payload
    def delete(path, accept, content = {})
      execute HttpConnect::HttpDelete.new(path, nil, accept, content)
    end

    private

    # open_connection()
    def open_connection(path)
      URI.parse(@base_url + path)
    end

    # apply_headers().
    # Helps apply all the custom http headers set.
    def apply_headers(request)
      @custom_headers.each do |key, value|
        request.add_field key, value
      end
    end

    # do_http_request()
    # Helps prepare and execute http web request
    # @param path the resource path
    # @param http_method the http verb used to access the resource
    # @param content_type the content type used to access the resource
    # @param accept the accept response header
    # @param content the request payload
    # @return HttpResponse instance
    def do_http_request(path, http_method, content_type, accept, content = {})
      uri = open_connection path
      request = extract_request(uri, http_method)
      request.content_type = content_type unless content_type.to_s.empty?
      request['Accept'] = accept
      apply_headers request
      if (%w[POST PUT].include? http_method) && !content.empty?
        handle_content request, content_type, content
      end
      fire_request(uri, request)
    end

    def handle_content(request, content_type, content)
      case content_type
      when DEFAULT_CONTENT_TYPE then
        request.body = content.to_json
        request.add_field 'Content-Length', request.body.size
      when FORM_DATA then request.set_form_data(content)
      else request.set_form_data(content)
      end
    end

    # fire_request()
    # @param uri the request URI object
    # @param request the http request object
    # @return HttpResponse instance
    def fire_request(uri, request)
      response = Net::HTTP.start(uri.host,
                                 use_ssl: @use_ssl,
                                 read_timeout: @read_write_timeout) do |http|
        http.request(request)
      end
      extract_response response
    end

    # extract_request()
    # @param uri the request URI object
    # @param http_method the request http method used
    # @return the http request object
    def extract_request(uri, http_method)
      request = case http_method
                when 'POST' then Net::HTTP::Post.new(uri)
                when 'GET' then Net::HTTP::Get.new(uri)
                when 'DELETE' then Net::HTTP::Delete.new(uri)
                when 'PUT' then Net::HTTP::Put.new(uri)
                else raise 'invalid http method'
                end
      request
    end

    # extract_response()
    # @param response the Net::HTTPResponse object to extract
    def extract_response(response)
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection then
        HttpConnect::HttpResponse.new(response.code.to_i,
                                      response.body, response.to_hash)
      else
        response.value
      end
    end
  end
end
