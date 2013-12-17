require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookies = req.cookies
    cookie = cookies.find{ |cookie| cookie.name == "_rails_lite_app" }
    if cookie
      @cookie = JSON.parse(cookie.value)
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key.to_s]
  end

  def []=(key, val)
    @cookie[key.to_s] = val
  end

  def store_session(res)
    session = @cookie.to_json
    cookie = WEBrick::Cookie.new("_rails_lite_app", session)
    res.cookies << cookie
  end
end
