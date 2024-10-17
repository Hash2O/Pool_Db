defmodule PoolDb.Repo do
  use Ecto.Repo,
    otp_app: :pool_db,
    adapter: Ecto.Adapters.Postgres
end
