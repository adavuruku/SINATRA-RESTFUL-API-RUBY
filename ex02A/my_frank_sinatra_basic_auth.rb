require 'sinatra'

set :bind, '0.0.0.0'
set :port, 8080

def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ["admin","admin"]
end

def protected!
    unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
    end
end

get "/protected" do
    protected!
    "Welcome, authenticated client"
end

get "/" do
    "Everybody can see this page"
end