module HttpConnect
  # HttpRequest class
  class HttpRequest
    attr_reader :path # resource path
    attr_reader :http_method # http verb
    attr_reader :accept # accept header for the response
    attr_reader :content # payload
    attr_reader :content_type # content type

    # initialize()
    def initialize(path, method, content_type = 'application/json',
                   accept = 'application/json', content = {})
      @path = path
      @http_method = method
      @accept = accept
      @content = content
      @content_type = content_type

      @path << "? #{URI.encode_www_form(@content)}" if %w[GET DELETE].include? @http_method
    end
  end
end
