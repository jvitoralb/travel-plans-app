require "../service/service"

BASE_URL = "/travel_plans"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  answer = { status: "online" }.to_json

  halt env, status_code: 200, response: answer
end

post BASE_URL do |env|
  data = Array(Int32).from_json(env.params.json["travel_stops"].to_json)

  plan = TravelPlan.new({:travel_stops => data})
  plan.save

  answer = plan.to_json

  halt env, status_code: 201, response: answer
end

get BASE_URL do |env|
  optimize = env.params.query["optimize"]?
  expand = env.params.query["expand"]?

  plan = TravelPlan.all()

  if optimize == "true"
    optimized_plans = optimize_all(plan)

    if expand == "true"
      expanded_optimized = expand_optimize_all(optimized_plans)
      halt env, status_code: 200, response: expanded_optimized.to_json
    end

    halt env, status_code: 200, response: optimized_plans.to_json
  end

  if expand == "true"
    expanded_answer = expand_all(plan)
    halt env, status_code: 200, response: expanded_answer.to_json
  end

  halt env, status_code: 200, response: plan.to_json
end

get BASE_URL + "/:id" do |env|
  optimize = env.params.query["optimize"]?
  expand = env.params.query["expand"]?
  id = env.params.url["id"].to_i

  if TravelPlan.where { _id == id }.exists? == false
    halt env, status_code: 200
  end

  plan = TravelPlan.find!(id)
  init_ans = { id: plan.id }
  
  if optimize == "true"
    optimized_stops = optimize(plan.travel_stops)

    if expand == "true"
      expand_optimize = init_ans.merge({ travel_stops: expand(optimized_stops) })
      halt env, status_code: 200, response: expand_optimize.to_json
    end

    optimize_answer = init_ans.merge({ travel_stops: optimized_stops })
    halt env, status_code: 200, response: optimize_answer.to_json
  end

  if expand == "true"
    expand_answer = init_ans.merge({ travel_stops: expand(plan.travel_stops) })
    halt env, status_code: 200, response: expand_answer.to_json
  end

  halt env, status_code: 200, response: plan.to_json
end

put BASE_URL + "/:id" do |env|
  id = env.params.url["id"].to_i

  if TravelPlan.where { _id == id }.exists? == false
    halt env, status_code: 200
  end

  travel_stops = Array(Int32).from_json(env.params.json["travel_stops"].to_json)

  plan = TravelPlan.where { _id == id }.update { {:travel_stops => travel_stops} }

  halt env, status_code: 200, response: TravelPlan.find!(id).to_json
end

delete BASE_URL do |env|
  truncate = env.params.query["truncate"]?

  if truncate == "true"
    Jennifer::Adapter.default_adapter.truncate(TravelPlan)
  end

  halt env, status_code: 204
end

delete BASE_URL + "/:id" do |env|
  id = env.params.url["id"].to_i

  plan = TravelPlan.delete(id)

  halt env, status_code: 204
end

error 400 do |env|
  env.get "400 error"
end
