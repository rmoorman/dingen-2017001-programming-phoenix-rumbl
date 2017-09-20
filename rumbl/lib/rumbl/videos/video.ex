defmodule Rumbl.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Videos.Video


  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    #field :user_id, :id
    belongs_to :user, Rumbl.User
    belongs_to :category, Rumbl.Category

    timestamps()
  end


  @permitted_fields [:url, :title, :description, :category_id]
  @required_fields [:url, :title, :description]

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @permitted_fields)
    |> assoc_constraint(:category)
    |> validate_required(@required_fields)
  end
end
