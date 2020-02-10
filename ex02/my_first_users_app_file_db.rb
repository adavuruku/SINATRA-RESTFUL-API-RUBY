require "sinatra"
enable :sessions

set :bind, '0.0.0.0'
set :port, 8080

class User
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

     def all
        loadDB
        @list_record.to_s
    end

    def validateUser(email,password)
        loadDB
        sam=""
        if @list_record.length > 0
            #@list_record.select { |hash| hash.values.any? { |v| v.to_s == email and v.to_s == password } }.to_s
             #@list_record.detect {|father| father["userId"].to_s ==user_id }.to_s
            result = @list_record.select {|row| row["email"].to_s ==email and row["password"].to_s ==password }
            if result.length > 0
                sam = result[0]["userId"] #session["userID"] = 
            end
        end
        return sam
    end

    def get(user_id)
        loadDB
        if user_id.length > 0 and @list_record.length > 0
            @list_record.select { |hash| hash.values.any? { |v| v.to_s == user_id } }.to_s
            #@list_record.select {|father| father["userId"].to_s ==user_id }.to_s
            #@list_record.detect {|father| father["userId"].to_s ==user_id }.to_s
        end
    end

    def update(user_id, password)
        loadDB
        if user_id.length > 0 and  @list_record.length >0
            @list_record.each{|v| v["password"] = password if v["userId"].to_s == user_id }
            msg = 'Record Updated Succesfully'
            saveToDb(msg)
        end
    end

    def destroy(user_id)
        loadDB
        if user_id.length > 0 and  @list_record.length >0
            @list_record.each{|v| @list_record.delete_at(@list_record.find_index(v)) if v["userId"].to_s == user_id } 
            msg = 'Record Removed / Deleted Succesfully'
            saveToDb(msg)
        end
    end
end

newRecord = User.new

post '/users' do
   userInfo = Hash.new
   userInfo["userId"] = rand(100000..990000).to_s
   userInfo["firstName"] = params[:firstName]
   userInfo["lastName"] = params[:lastName]
   userInfo["age"] = params[:age]
   userInfo["password"] = params[:password]
   userInfo["email"] = params[:email]
   newRecord.create(userInfo)
end

get '/users' do
   newRecord.all
end

post '/sign_in' do
   email = params[:email]
   password = params[:password]
   p email
   p password
   signIn = newRecord.validateUser(email,password)
   if signIn.length > 0
        session["userID"] = signIn
        'Successfully Logged In'
    else
        'Failled To Logged In Invalid email or Password!'
    end
end

put '/users' do
    if session["userID"] != nil
        sesValue = session["userID"]
        newRecord.update(sesValue,params[:password])
    else
        'This Action Required User To Be Logged In.'
    end
end

delete '/sign_out' do
   if session["userID"]!=nil
        session["userID"]=nil
        'User Successfully Logged Out !'
    else
        'This Action Required User To Be Logged In.'
    end
end

delete '/users' do
   if session["userID"]!=nil
        sesValue = session["userID"]
        session["userID"]=nil
        newRecord.destroy(sesValue)
    else
        'This Action Required User To Be Logged In.'
    end
end