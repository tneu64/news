require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "a6dd754efac5800f8c0151b9852b4cbf"

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates # => [lat, long]
    "#{lat_long[0]} #{lat_long[1]}"

    # plug it into Dark Sky
        @forecast = ForecastIO.forecast("#{lat_long[0]}", "#{lat_long[1]}").to_hash
            @current_temp = @forecast["currently"]["temperature"]
            @current_summary = @forecast["currently"]["summary"]
            @daily_forecast = @forecast["daily"]["data"]
        
    # get some headlines
       url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8ce8bb1151b149e09f18687474252e73"
        @news = HTTParty.get(url).parsed_response.to_hash
        @articles = @news["articles"]
        
    view "news"
end



       
