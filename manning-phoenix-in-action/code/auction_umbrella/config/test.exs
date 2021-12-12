import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :auction_web, AuctionWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5xaPof5t/AJE94ef84vpBMT6jem2248H9lOqEmRRq2gqmRL4rtBg3+8D7/PCM2Hq",
  server: false
