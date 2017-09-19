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

  @required_fields [:url, :title, :description]
  @optional_fields [:category_id]

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end
end
