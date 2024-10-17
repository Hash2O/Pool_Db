defmodule PoolDbWeb.PageController do
  use PoolDbWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def users(conn, _params) do
    # Log msg in console
    IO.puts("Users function called !")
    # hard coding datas for start
    users = [
      %{id: 1, name: "Thilega", email: "thilega@email.com"},
      %{id: 2, name: "Alice", email: "alice@email.com"},
      %{id: 3, name: "John", email: "john@email.com"}
    ]
    # Using render will render HTML format
    # render(conn, :users, users: users, layout: false)
    # using json will format data as JSON
    json(conn, %{users: users})
  end
end
