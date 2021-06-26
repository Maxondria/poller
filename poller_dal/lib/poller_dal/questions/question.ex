defmodule PollerDal.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "questions" do
    field(:description, :string)
    belongs_to(:district, PollerDal.Districts.District)
    has_many(:choices, PollerDal.Choices.Choice)

    timestamps()
  end

  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:description, :district_id])
    |> validate_required([:description, :district_id])
    # verify that the district_id actually exists in the districts table
    |> assoc_constraint(:district)
  end
end
