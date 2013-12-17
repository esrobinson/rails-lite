require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @request = req
    @response = res
    @params = route_params
  end

  def session
  end

  def already_rendered?
  end

  def redirect_to(url)
    @response.header["location"] = url.to_s
    @response.status = 302
  end

  def render_content(content, type)
    @response.content_type = type
    @response.body = content
    @already_build_response = true
  end

  def render(template_name)
  end

  def invoke_action(name)
  end
end
