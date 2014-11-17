class PageParser
  attr_reader :body, :status, :headers

  def initialize(url)
    @url = url
  end

  def fetch
    raise if uri.host =~ /localhost|127.0.0.1|0.0.0.0/

    Timeout.timeout(5) do
      @response = HTTP.head(@url)

      update_response_state
    end

    # Only fetch the body if it looks like we'll get back html
    fetch_body if html? && !gzipped?
  rescue
    Rails.logger.warn($!)
    # Fail everything as a timeout for now
    @status = -1
    @headers = {}
  ensure
    return self
  end

  def uri
    @uri ||= Addressable::URI.parse(@url)
  end

  def html?
    # Hack for sites that don't support head requests (404, 405 response)
    (status == 200 || status == 405 || status == 404) && content_type && content_type =~ /text\/html/
  end

  def gzipped?
    content_encoding =~ /gzip/
  end

  def failed?
    status == -1
  end

  def content_type
    headers['Content-Type']
  end

  def content_encoding
    headers['Content-Encoding']
  end

  def title
    doc.title if doc
  end

  def content
    doc.content if doc
  end

  private

    def fetch_body
      @response = HTTP.get(@url)
      @body = @response.to_s

      update_response_state
    end

    def doc
      if body
        @doc ||= Readability::Document.new(body, tags: %w[div p img a pre], attributes: %w[src href], remove_empty_nodes: false)
      end
    end

    def update_response_state
      @headers = @response.headers
      @status = @response.status
    end
end
