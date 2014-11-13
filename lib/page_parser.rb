class PageParser
  attr_reader :body, :status, :headers

  def initialize(url)
    @url = url
  end

  def fetch
    raise if uri.host =~ /localhost|127.0.0.1|0.0.0.0/

    Timeout.timeout(2) do
      @response = HTTP.head(@url)
      @headers = @response.headers
      @status = @response.status
    end

    # Only fetch the body if it looks like we'll get back html
    fetch_body if html? && !gzipped?
  rescue
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
    status == 200 && content_type && content_type =~ /text\/html/
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
      @body = HTTP.get(@url).to_s
    end

    def doc
      if body
        @doc ||= Readability::Document.new(body, tags: %w[div p img a], attributes: %w[src href], remove_empty_nodes: false)
      end
    end
end
