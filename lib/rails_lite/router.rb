class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    req.request_method == @http_method.to_s.upcase && @pattern.match(req.path)
  end

  def run(req, res)
    params = match_data(req)
    @controller_class.new(req, res, params).invoke_action(@action_name)
  end

  def match_data(req)
    match = @pattern.match(req.path)
    Hash[match.names.zip(match.captures)]
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.find{ |route| route.matches?(req) }
  end

  def run(req, res)
    route = self.match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
    end
  end
end
