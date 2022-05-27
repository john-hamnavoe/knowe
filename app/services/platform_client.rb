class PlatformClient
  include ERB::Util
  attr_accessor :token

  # Initializes the PlatformClient
  # pass in config PlatformConfiguration
  def initialize(project)
    @pat_token = project.pat_token
    @base_url = project.base_url
    @auth_cookie = project.auth_cookie
  end

  def pat_authorization_url
    "https://#{@base_url}/authTokens?privatekey=#{@pat_token}"
  end

  def pat_login
    begin
      response = HTTParty.post(pat_authorization_url)
      @auth_cookie = response.headers["set-cookie"]
    rescue HTTParty::Error
      @auth_cookie = nil
    rescue StandardError
      @auth_cookie = nil
    end
    @auth_cookie
  end

  def query(resource)
    url = "https://#{@base_url}/#{resource}"
    HTTParty.get(url, options)
  end

  def query_with_filter(resource, filter)
    url = "https://#{@base_url}/#{resource}?#{filter}"
    HTTParty.get(url, options)
  end

  def query_changes(resource, since, cursor)
    query = ""
    query = "?since=#{url_encode(since)}" if since.present?
    query = "?cursor=#{url_encode(cursor)}" if cursor.present?
    url = "https://#{@base_url}/#{resource}#{query}"
    HTTParty.get(url, options)
  end

  def post(resource, body)
    url = "https://#{@base_url}/#{resource}"
    HTTParty.post(url, body: body, headers: options[:headers], timeout: 180)
  end

  def put(resource, body)
    url = "https://#{@base_url}/#{resource}"
    HTTParty.put(url, body: body, headers: options[:headers], timeout: 180)
  end

  private

  def options
    {
      headers: {
        Cookie: @auth_cookie.to_s
      }
    }
  end
end
