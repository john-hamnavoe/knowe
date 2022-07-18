# frozen_string_literal: true

class ApplicationAdapter
  attr_accessor :project, :user, :platform_client, :last_response_code, :last_repsonse_body

  def initialize(user, project = nil)
    @project = project || user.current_project
    @user = user
    @platform_client = PlatformClient.new(@project)
    platform_client.pat_login
  end

  def reauthenticate
    platform_client.pat_login
  end

  private

  def post(path, data)
    response = platform_client.post(path, data)
    if response.code == 401 
      reauthenticate
      response = platform_client.post(path, data)
    end    
    AdapterResponse.new(response)
  end

  def put(path, guid, data)
    response = platform_client.put("#{path}/#{guid}", data)
    AdapterResponse.new(response)
  end

  def query(resource)
    response = platform_client.query(resource)
    AdapterResponse.new(response)
  end

  def query_with_filter(resource, filter)
    response = platform_client.query_with_filter(resource, filter)
    AdapterResponse.new(response)
  end

  def query_changes(resource, since, cursor)
    response = platform_client.query_changes(resource, since, cursor)
    if response.code == 401 
      reauthenticate
      response = platform_client.query_changes(resource, since, cursor)
    end
    AdapterResponse.new(response)
  end
end
