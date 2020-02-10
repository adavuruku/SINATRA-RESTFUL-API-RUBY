require 'sinatra'
enable :cookies

set :bind, '0.0.0.0'
set :port, 8080

class Cook
    attr_reader :list_record
    def initialize
        @list_record  = Array.new
        loadDB
    end
    def saveToDb(msg)
        file = File.open("cook.txt", "w")
        file.write(@list_record)
        file.close()
        msg.to_s
    end
    def loadDB
        file = File.open("cook.txt", "a+")
        @list_record = eval(file.read()).to_a
        file.close()
    end
    def createCookie(myKey,myValue)
        newCook = Hash.new
        newCook[myKey] = myValue
        #create new if it doesnt exist
        list_record.push(newCook) unless list_record.include?(newCook)
        msg = 'Cokie Successfully Created!'
        saveToDb(msg)
    end
    def retrieveOrDelete(action,myKey,cookVal)
        if action =="get"
            cookval = list_record.select {|cook| cook.key?(myKey)}
            if cookval.length > 0
                cookval[0][myKey].to_s
            end
        else
            list_record.each{|v| list_record.delete_at(list_record.find_index(v)) if v.key?(myKey) }
            msg = 'Cookie Removed / Deleted Succesfully'
            saveToDb(msg)
        end
    end
end

myCook = Cook.new
get '/cookie_chocolate' do
    action = params[:action]
    myKey = params[:name]
    myValue = params[:value]
    response.set_cookie(myKey, myValue)
    myCook.createCookie(myKey,myValue)
end
 
get '/j03/ex03/cookie_crisp.php' do
    action = params[:action]
    myKey = params[:name]
    cookval = request.cookies[myKey]
    response.set_cookie(myKey, "")
    myCook.retrieveOrDelete(action,myKey,cookval)
end