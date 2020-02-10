require 'sinatra'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do
    songList = ["Ac-cent-tchu-ate the Positive","Accidents Will Happen","Adeste Fideles","Ad-Lib Blues",
"An Affair to Remember", "After You've Gone","Ain't She Sweet","Ain't Cha Ever Comin' Back?",
"Air For English Horn","All Alone","All By Myself","All I Do Is Dream of You", "All I Need is the Girl",
"All My Tomorrows","All of Me","All of You", "All or Nothing at All", "All the Things You Are","All the Way",
"All the Way Home","All This and Heaven Too","All Through the Day", "Almost Like Being in Love", "Always",
"America the Beautiful","American Beauty Rose","Among My Souvenirs","And Then You Kissed Me","Angel Eyes",
"Down Where the Trade Winds Play"]
    songList[rand(0..29)]

end
get '/picture' do
    '<img src="https://upload.wikimedia.org/wikipedia/commons/a/af/Frank_Sinatra_%2757.jpg" />'
end
get '/wifes' do
    'Barbara Sinatra, Ava Gardner, Mia Farrow, Nancy Barbato'
end

get '/birth_date' do
    'December 12, 1915'
end

get '/birth_city' do
    'Hoboken, New Jersey, United States'
end