# Travels Booker

### CREATE
Para criar um documento no banco de dados:

POST request ao endpoint `/travel_plans` com o body `{ travel_stops: [1,2,3] }`.

Ao fim ele retorna `status_code: 201`, e body: `{ id: 1, travel_stops: [1,2,3] }`.

Se o arranjo estiver vazio, ele retorna `status_code: 400` e uma mensagem de erro.

### READ
Para ler um documento no banco de dados:

GET request ao endpoint `/travel_plans`.

Ao fim ele retorna `status_code: 200`, e body: `[{ id: 1, travel_stops: [1,2,3] }]`.

Caso banco de dados esteja vazio ele retorna `status_code: 200`, e body: `[]`.

### UPDATE
Para alterar um documento no banco de dados:

PUT request ao endpoint `/travel_plans/1`, usando o id do documento a ser alterado como url params e com o body `{ travel_stops: [5, 8, 9] }`.

Ao fim ele retorna `status_code: 200`, e body: `{ id: 1, travel_stops: [5, 8, 9] }`.

Se o arranjo estiver vazio, ele retorna `status_code: 400` e uma mensagem de erro.

### DELETE
Para deletar um documento no banco de dados:

Enviar DELETE request ao endpoint `/travel_plans/1` usando o id do documento a ser deletado como url params.

Ao fim ele retorna `status_code: 204` e body: `""`
