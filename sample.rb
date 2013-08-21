require 'sinatra/base' #sinatra
require 'fontaine/canvas' #the meat of everything canvas-related
require 'fontaine/bootstrap' #bootstraps the fontaine javascript file
require 'sinatra-websocket' #gives us the power of websocket!
require 'haml' #not strictly necessary, but recommended

class Sample < Sinatra::Base
  register Sinatra::Fontaine::Bootstrap::Assets
  set :server, 'thin'
  set :sockets, []
  
  get '/' do
    
    @canvas = Fontaine::Canvas.new("TEST_CANVAS", 500, 500, 
      "Your browser does not support the canvas tag", 
      :style => "border:1px solid #000000;") do |canvas|
        
        canvas.on_click do |x, y, button| #when there's a click, do this:
          canvas.rect(x.to_i-25, y.to_i-25, 50, 50)
          
          if button.eql? '0' #left click will give you a solid red rectangle
            canvas.fill_style("#FF0000")
            canvas.fill
          else #right click will give you the outline of a blue rectangle
            canvas.stroke_style("blue")
            canvas.stroke
          end
          
        end
    end

    if request.websocket?
      @canvas.listen(request, settings)
    else
      haml :index
    end
  end
  
end