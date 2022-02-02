config :auction, ecto_repos: [Auction.Repo]

config :auction, Auction.Repo,
  database: "auction",
  username: "auction",
  password: "password",
  hostname: "localhost",
  port: "5432"
