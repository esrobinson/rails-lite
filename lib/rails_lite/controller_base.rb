require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res)
    @request = req
    @response = res
    route_params = @request.body || ""
    @params = Params.new(@request, route_params)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
  end

  def redirect_to(url)
    self.session.store_session(@response)
    @response.header["location"] = url.to_s
    @response.status = 302
  end

  def render_content(content, type)
    self.session.store_session(@response)
    @response.content_type = type
    @response.body = content
    @already_build_response = true
  end

  def render(template_name)
    template = File.read(
      "views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    template = ERB.new(template)
    result = template.result(binding)
    render_content(result, "text/html")
  end

  def invoke_action(name)
  end
end
