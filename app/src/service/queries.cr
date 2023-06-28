class GraphQLQueries
  getter api

  def initialize
    @api = GraphQLClient.new "https://rickandmortyapi.com/graphql"
  end

  def query_all_pop
    data, error, loading = self.api.query(
      "{
          locations {
            results {
              id
              name
              dimension
              residents {
                episode {
                  id
                }
              }
            }
          }
        }"
    )

    data
  end

  def query_by_id_pop(stops)
    data, error, loading = self.api.query(
      "{
          locationsByIds(ids: #{stops}) {
            id
            name
            dimension
            residents {
              episode {
                id
              }
            }
          }
        }"
    )

    data
  end

  def query_all
    data, error, loading = self.api.query(
      "{
          locations {
            results {
              id
              name
              type
              dimension
            }
          }
        }"
    )

    data
  end

  def query_by_id(stops)
    data, error, loading = self.api.query(
      "{
          locationsByIds(ids: #{stops}) {
            id
            name
            type
            dimension
          }
        }"
    )

    data
  end

end
