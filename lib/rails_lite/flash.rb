require 'json'
require 'webrick'

class Flash
  def initialize(req)
    @new_cookie = {}
    cookies = req.cookies
    cookie = cookies.find{ |cookie| cookie.name == "_rails_lite_flash" }
    if cookie
      @old_cookie = JSON.parse(cookie.value)
    else
      @old_cookie = {}
    end
  end

  def [](key)
    @old_cookie[key.to_s]
  end

  def now
    @old_cookie
  end

  def []=(key, value)
    @new_cookie[key.to_s] = value
  end

  def store_flash(res)
    res.cookies << WEBrick::Cookie.new("_rails_lite_flash", @new_cookie.to_json)
  end

end