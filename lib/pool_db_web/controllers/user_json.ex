defmodule PoolDbWeb.UserJSON do
  alias PoolDb.Accounts.User
  alias PoolDbWeb.PostJSON
  # alias PoolDb.Posts.Post

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      posts: for(post <- user.posts, do: PostJSON.data(post))
    }
  end

  # to show posts owned by an user
  # def post_data(%Post{} = post) do
  #   %{
  #     id: post.id,
  #     title: post.title,
  #     body: post.body
  #   }
  # end
end
