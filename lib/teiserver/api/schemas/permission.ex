defmodule Teiserver.Api.Permission do
  @moduledoc false
  use TeiserverWeb, :schema

  @type t :: %__MODULE__{
          name: String.t(),
          module: module()
        }

  schema "api_permissions" do
    field :name, :string, primary_key: true
    field :module, :atom
  end

  def changeset(permission, attrs \\ %{}) do
    permission
    |> cast(attrs, ~w(name module))
    |> validate_required([:name, :module])
  end
end
