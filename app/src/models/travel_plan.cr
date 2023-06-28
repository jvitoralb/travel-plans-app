class TravelPlan < Jennifer::Model::Base

  mapping(
    id: Primary64,
    travel_stops: Array(Int32)
  )
end
