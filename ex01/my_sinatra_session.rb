require 'sinatra'
enable :sessions

set :bind, '0.0.0.0'
set :port, 8080

get '/cookie_chocolate' do
    myKey = params[:name]
    myValue = params[:value]
    myAction = params[:action]
    if myAction=="set"
        session[myKey] = myValue
        'New Session Created Successfully'
    elsif myAction=="get" and session[myKey].inspect != nil
        session[myKey].inspect
    else
        session[myKey] = nil
    end
end