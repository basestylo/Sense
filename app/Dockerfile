FROM bitwalker/alpine-elixir-phoenix:1.8.1
MAINTAINER David Martin <davidmartingarcia0@gmail.com>

# Set exposed ports
EXPOSE 4000
WORKDIR /app

ENV PORT=4000 MIX_ENV=prod

# Cache elixir deps
RUN mix local.hex --force && \
    mix local.rebar --force
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile


# Same with npm deps
ADD package.json ./
RUN npm install

ADD . .

# Use for frontend versions - Run frontend build, compile, and digest assets
# RUN npm run deploy && \
#    mix do compile, phx.digest

RUN mix compile

ENTRYPOINT []
CMD ["mix", "phx.server"]
