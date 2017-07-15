require 'http_connect/http_request'

module HttpConnect
  # HttpDelete class
  class HttpDelete < HttpRequest
    # initialize()
    def initialize(path, content_type = 'application/json',
                   accept = 'application/json', content = {})
      super(path, 'DELETE', content_type, accept, content)
    end
  end
end
