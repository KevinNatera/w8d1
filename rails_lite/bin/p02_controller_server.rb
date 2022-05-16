require 'rack'
require_relative '../lib/controller_base'

class MyController < ControllerBase

  def initialize(req, res)
    @req = req
    @res = res 
  end 

  def render_content(content,content_type)
    if !@already_built_response
      @res.write(content)
      @res["Content-Type"] = content_type 
      @already_built_response = true  
      nil
    end
  end 

  def redirect_to(url)
      if !@already_built_response
        @res.status = 302
        @res["Location"] = url 
        nil
        @already_built_response = true 
      end
  end 

  def go
    if req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)

