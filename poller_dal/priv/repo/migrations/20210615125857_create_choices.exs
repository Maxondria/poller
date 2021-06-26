defmodule PollerDal.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add(:description, :string)
      add(:question_id, references(:questions, on_delete: :delete_all))

      timestamps()
    end

    # Index the question_id because we are likely to call this all the time
    create(index(:choices, [:question_id]))
  end
end
