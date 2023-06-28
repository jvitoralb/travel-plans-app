require "./spec_helper.cr"

describe "App status" do
  it "Request to root" do
    get "/"

    response.status_code.should eq 200
  end
end

describe "CRUD operations to /travel_plans" do
  describe "Create a new travel plan" do
    it "A simple POST" do
      post_body = {"travel_stops": [1, 2]}
      post(
        "/travel_plans",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: post_body.to_json
      )

      parsed_res = JSON.parse(response.body)

      response.status_code.should eq 201
      response.content_type.should eq "application/json"
      parsed_res["id"].nil?.should be_false
      parsed_res["travel_stops"].should eq post_body["travel_stops"]
    end
  end

  describe "Get all travel plans" do
    it "GET with no params" do
      get "/travel_plans"

      response.status_code.should eq 200
      response.content_type.should eq "application/json"
      response.body.should eq([
        {
          "id":           1,
          "travel_stops": [1, 2],
        },
      ].to_json)
    end

    it "GET with params optimize to false and expand to true" do
      get "/travel_plans?optimize=false&expand=true"

      response.status_code.should eq 200
      response.content_type.should eq "application/json"
      response.body.should eq([
        {
          "id":           1,
          "travel_stops": [
            {
              "id":        1,
              "name":      "Earth (C-137)",
              "type":      "Planet",
              "dimension": "Dimension C-137",
            },
            {
              "id":        2,
              "name":      "Abadango",
              "type":      "Cluster",
              "dimension": "unknown",
            },
          ],
        },
      ].to_json)
    end
  end

  describe "Get a especific travel plan" do
    it "GET with a travel plan id" do
      get "/travel_plans/1"

      response.status_code.should eq 200
      response.content_type.should eq "application/json"
      response.body.should eq({
        "id":           1,
        "travel_stops": [1, 2],
      }.to_json)
    end

    it "GET with a travel plan id and params optimize to false and expand to true" do
      get "/travel_plans/1?optimize=false&expand=true"

      response.status_code.should eq 200
      response.content_type.should eq "application/json"
      response.body.should eq({
        "id":           1,
        "travel_stops": [
          {
            "id":        1,
            "name":      "Earth (C-137)",
            "type":      "Planet",
            "dimension": "Dimension C-137",
          },
          {
            "id":        2,
            "name":      "Abadango",
            "type":      "Cluster",
            "dimension": "unknown",
          },
        ],
      }.to_json)
    end
  end
  describe "Update a existing travel plan" do
    it "PUT with travel id " do
      json_body = {"travel_stops": [4, 5, 6]}
      put(
        "/travel_plans/1",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: json_body.to_json
      )

      response.status_code.should eq 200
      response.body.should eq({
        "id":           1,
        "travel_stops": [4, 5, 6],
      }.to_json)
    end
  end

  describe "Delete a existing travel plan" do
    it "DELETE with travel id " do
      delete "/travel_plans/1"

      response.status_code.should eq 204
      response.body.should eq ""
    end
  end
end
