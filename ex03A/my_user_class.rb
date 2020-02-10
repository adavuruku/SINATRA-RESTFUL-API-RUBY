require "sinatra"

set :bind, '0.0.0.0'
set :port, 8080

class Example
    attr_reader :list_record
    def initialize
        @list_record  = Array.new
        loadDB
    end
    def saveToDb(msg)
        file = File.open("db.raw", "w")
        file.write(@list_record)
        file.close()
        msg.to_s
    end
    def loadDB
        file = File.open("db.raw", "a+")
        @list_record = eval(file.read()).to_a
        file.close()
    end

    def create(user_info)
        if user_info.length > 0
            @list_record.push(user_info)
            msg = "New User Created With an ID #{user_info['userId']}"
            saveToDb(msg)
        end
        
    end
    def get(user_id)
        loadDB
        if user_id.length > 0 and @list_record.length > 0
            @list_record.select { |hash| hash.values.any? { |v| v.to_s == user_id  } }.to_s
           # @list_record.select {|father| father["userId"].to_s =="874062" }.to_s
            #@list_record.detect {|father| father["userId"].to_s ==user_id }.to_s
        end
    end
    def all
        loadDB
        @list_record.to_s
    end
    def update(user_id, attribute, value)
        loadDB
        if user_id.length > 0 and @list_record.length > 0
            @list_record.each{|v| v[attribute] = value if v["userId"].to_s == user_id }
            msg = 'Record Updated Succesfully'
            saveToDb(msg)
        end
    end

    def destroy(user_id)
        loadDB
        if user_id.length > 0 and @list_record.length > 0
            @list_record.each{|v| @list_record.delete_at(@list_record.find_index(v)) if v["userId"].to_s == user_id } 
            msg = 'Record Removed / Deleted Succesfully'
            saveToDb(msg)
        end
    end
end

newRecord = Example.new

post '/addNewUser' do
   userInfo = Hash.new
   userInfo["userId"] = rand(100000..990000).to_s
   userInfo["firstName"] = params[:firstName]
   userInfo["lastName"] = params[:lastName]
   userInfo["age"] = params[:age]
   userInfo["password"] = params[:password]
   userInfo["email"] = params[:email]
   newRecord.create(userInfo)
end

get '/findSingleUser' do
    p params[:userId]
   newRecord.get(params[:userId])
end
get '/allUser' do
   newRecord.all
end

put '/updateUser' do
   newRecord.update(params[:userId],params[:field],params[:value])
end

delete '/removeUser' do
   newRecord.destroy(params[:userId])
end