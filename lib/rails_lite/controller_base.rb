require 'erb'
require_relative 'params'
require_relative 'session'
require_relative 'flash'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    @request = req
    @response = res
    route_params ||= ""
    @params = Params.new(@request, route_params)
  end

  def session
    @session ||= Session.new(@request)
  end

  def flash
    @flash ||= Flash.new(@request)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    store_cookies
    @response.header["location"] = url.to_s
    @response.status = 302
    @already_built_response = true
  end

  def render_content(content, type)
    # store_cookies
    @response.content_type = type
    @response.body = content
    @already_built_response = true
  end

  def render(template_name)
    store_cookies
    template = File.read(
      "views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    template = ERB.new(template)
    result = template.result(binding)
    render_content(result, "text/html")
    @already_built_response = true
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_rendered?
  end

  def store_cookies
    self.session.store_session(@response)
    self.flash.store_flash(@response)
  end
end
