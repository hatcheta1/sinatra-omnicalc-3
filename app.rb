require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get("/umbrella") do
  erb(:umbrella_form)
end

get("/process_umbrella") do
  @user_location = params.fetch("user_loc")

  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{params.fetch("user_loc")}&key=#{ENV.fetch("GMAPS_KEY")}"

  @raw_response = HTTP.get("gmaps_url").to_s

  @parsed_response = JSON.parse(@raw_response)

  @loc_hash = @parsed_response.dig("results", 0, "geometry", "location")

  @latitude = @loc_hash.fetch("lat")
  @longitude = @loc_hash.fetch("lon")
  
  erb(:umbrella_results)
end
