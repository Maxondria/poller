defmodule PollerDal.Repo.Migrations.AddFieldsToChoices do
  use Ecto.Migration

  def change do
    alter table(:choices) do
      add(:votes, :integer)
      add(:party, :integer)
    end
  end
end
