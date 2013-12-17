require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    req.query_string ||= ""
    parse_www_encoded_form(req.query_string+route_params)
  end

  def [](key)
    @params[key.to_s]
  end

  def to_s
    @params.to_json
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    values = URI.decode_www_form(www_encoded_form)
    values.each { |key, value| update_key(key, value) }
    end
  end

  def update_key(key, value)
    key_levels = parse_key(key)
    last_key = key_levels.pop
    next_level = @params
    key_levels.each do |level|
      next_level[level] ||= {}
      next_level = next_level[level]
    end
    next_level[last_key] = value
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
