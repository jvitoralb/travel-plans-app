FROM crystallang/crystal:latest
WORKDIR /home/app
COPY /app /home/app
RUN shards install
CMD ["crystal", "/home/app/src/app.cr"]
EXPOSE 3000