defmodule Sourceplot.Repo do
  use Ecto.Repo,
    otp_app: :sourceplot,
    adapter: Ecto.Adapters.Postgres
end
