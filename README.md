# Travels App

API criada para um code challenge. Algumas das respostas da API são baseadas em informações externas, que são obtidas através de um GraphQL query para uma api de Rick and Morty.

## Como usar
- `shards install`: instalar dependencias;
- `make sam db:migrate`: após configurar o banco de dados, esse comando deve importar informações das tabelas para o DB;
- `crystal src/app.cr`: o app deve abrir na porta 3000;

## Ferramentas
A api foi construída em um ambiente Docker usando a linguagem crystal junto ao framework Kemal, e o banco de dados postgreSQL junto a ORM jennifer.
