defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :subtitle, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :subtitle, :content])
    |> validate_required([:title, :subtitle, :content])
    |> validate_length(:title, min: 3, max: 100)
    |> validate_length(:subtitle, min: 3, max: 100)
  end
end
