class TravelStopsHandler < Kemal::Handler
  only [BASE_URL], "POST"
  only [BASE_URL + "/:id"], "PUT"

  def call(env)
    return call_next(env) unless only_match?(env)

    arr_size = Array(Int32).from_json(env.params.json["travel_stops"].to_json).size

    if arr_size < 1
      env.response.status_code = 400
      env.set "400 error", {error: "invalid travel_stops value"}.to_json
      raise Kemal::Exceptions::CustomException.new env
    end

    puts "valid travel_stops value"
    return call_next(env)
  end
end
