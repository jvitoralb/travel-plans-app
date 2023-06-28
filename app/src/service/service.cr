require "crystal-gql"
require "./queries.cr"


def sort_by_popularity(arr)
  sorted = arr.sort { |a, b|
    if a["popularity"] == b["popularity"]
      a["name"] <=> b["name"]
    else
      a["popularity"] <=> b["popularity"]
    end
  }

  sorted
end


def optimize_all(plans)
  query = GraphQLQueries.new
  data = query.query_all_pop()

  parsed_data = Hash(String, Array(Hash(String, Int32 | String | Array(Hash(String, Array(Hash(String, Int32 | String))))))).from_json data["locations"].to_json
  tuple_arr = Array(NamedTuple(id: String, name: String, dimension: String, popularity: Int32, residents: Array(Hash(String, Array(Hash(String, String|Int32)))))).new

  parsed_data["results"].each { |x|
    ep_count = 0

    parsed_x = NamedTuple(id: String, name: String, dimension: String, residents: Array(Hash(String, Array(Hash(String, String|Int32))))).from(x)
    parsed_x["residents"].each { |resident| ep_count += resident["episode"].size}

    tuple_arr.push parsed_x.merge({ popularity: ep_count })
  }

  new_plans = Array(NamedTuple(id: Int64 | Nil, travel_stops: Array(Int32))).new
  
  plans.each { |plan|
    optimized_stops = Array(Int32).new
    temp_arr = Array(NamedTuple(id: String, name: String, dimension: String, popularity: Int32, residents: Array(Hash(String, Array(Hash(String, String|Int32)))))).new
    plan.travel_stops.each { |stop|
      tuple_arr.each { |x|
        if x["id"].to_i == stop
          temp_arr.push x
        end
      }
    }
    sorted = sort_by_popularity(temp_arr)
    sorted.each { |x| optimized_stops.push x["id"].to_i }

    new_plan = { id: plan.id, travel_stops: optimized_stops }
    new_plans.push new_plan
  }

  p new_plans
end

def optimize(stops : Array(Int32))
  query = GraphQLQueries.new
  data = query.query_by_id_pop(stops)

  parsed_data = Hash(String, Array(Hash(String, Int32 | String | Array(Hash(String, Array(Hash(String, Int32 | String))))))).from_json data.to_json
  tuple_arr = Array(NamedTuple(id: String, name: String, dimension: String, popularity: Int32, residents: Array(Hash(String, Array(Hash(String, String|Int32)))))).new

  parsed_data["locationsByIds"].each { |x|
    ep_count = 0

    parsed_x = NamedTuple(id: String, name: String, dimension: String, residents: Array(Hash(String, Array(Hash(String, String|Int32))))).from(x)
    parsed_x["residents"].each { |resident| ep_count += resident["episode"].size}
      
    tuple_arr.push parsed_x.merge({ popularity: ep_count })
  }

  sorted = sort_by_popularity(tuple_arr)
  optimized_stops = Array(Int32).new
  sorted.each { |x| optimized_stops.push x["id"].to_i }
  optimized_stops
end

def expand(stops : Array(Int32) | Nil)
  query = GraphQLQueries.new
  data = query.query_by_id(stops)

  parsed_data = Hash(String, Array(Hash(String, Int32 | String))).from_json data.to_json

  new_arr = Array(NamedTuple(id: String, name: String, type: String, dimension: String)).new

  stops.each { |x|
    parsed_data["locationsByIds"].each { |z|
      if z["id"] == x.to_s
        new_arr.push NamedTuple(id: String, name: String, type: String, dimension: String).from(z)
      end
    }
  }

  new_arr
end

def expand_optimize_all(plans)
  query = GraphQLQueries.new
  data = query.query_all()

  parsed_data = Hash(String, Array(Hash(String, Int32 | String))).from_json data["locations"].to_json
  expanded_plans = Array(NamedTuple(id: Int32 | Int64 | Nil, travel_stops: Array(NamedTuple(id: String, name: String, type: String, dimension: String)))).new
  
  plans.each { |plan|
    expanded_stops = Array(NamedTuple(id: String, name: String, type: String, dimension: String)).new
    plan["travel_stops"].each { |stop|
      expanded_stops.push NamedTuple(id: String, name: String, type: String, dimension: String).from(parsed_data["results"][stop - 1])
    }
    new_plan = { id: plan["id"], travel_stops: expanded_stops }
    expanded_plans.push new_plan
  }
  
  p expanded_plans
end

def expand_all(plans : Jennifer::QueryBuilder::ModelQuery(TravelPlan))
  query = GraphQLQueries.new
  data = query.query_all()

  parsed_data = Hash(String, Array(Hash(String, Int32 | String))).from_json data["locations"].to_json
  expanded_plans = Array(NamedTuple(id: Int32 | Int64 | Nil, travel_stops: Array(NamedTuple(id: String, name: String, type: String, dimension: String)))).new
  
  plans.each { |plan|
    expanded_stops = Array(NamedTuple(id: String, name: String, type: String, dimension: String)).new
    plan.travel_stops.each { |stop|
      expanded_stops.push NamedTuple(id: String, name: String, type: String, dimension: String).from(parsed_data["results"][stop - 1])
    }
    new_plan = { id: plan.id, travel_stops: expanded_stops }
    expanded_plans.push new_plan
  }
  
  p expanded_plans
end
