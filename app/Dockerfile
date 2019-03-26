FROM bitwalker/alpine-elixir-phoenix:latest
MAINTAINER David Martin <davidmartingarcia0@gmail.com>

# Set exposed ports
EXPOSE 4000
WORKDIR /app

ENV PORT=4000 MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest

ENTRYPOINT []
CMD ["mix", "phoenix.server"]
