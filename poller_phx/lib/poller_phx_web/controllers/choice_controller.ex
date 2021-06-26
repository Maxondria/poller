defmodule PollerPhxWeb.ChoiceController do
  # require Logger
  # Logger.debug("Choices: #{inspect(choices)}")
  use PollerPhxWeb, :controller

  alias PollerDal.Districts
  alias PollerDal.Questions
  alias PollerDal.Choices
  alias PollerDal.Choices.Choice

  def index(conn, %{"district_id" => district_id, "question_id" => question_id}) do
    district = Districts.get_district!(district_id)
    question = Questions.get_question!(question_id)
    choices = Choices.list_choices_by_question_id(question.id)

    render(conn, "index.html", district: district, question: question, choices: choices)
  end

  def new(conn, %{"district_id" => district_id, "question_id" => question_id}) do
    district = Districts.get_district!(district_id)
    question = Questions.get_question!(question_id)
    changeset = Choices.change_choice(%Choice{})

    render(conn, "new.html", changeset: changeset, district: district, question: question)
  end

  def create(conn, %{
        "district_id" => district_id,
        "question_id" => question_id,
        "choice" => choice_params
      }) do
    choice_params = Map.merge(choice_params, %{"question_id" => question_id})

    case Choices.create_choice(choice_params) do
      {:ok, _choice} ->
        conn
        |> put_flash(:info, "Choice created successfully.")
        |> redirect(to: Routes.choice_path(conn, :index, district_id, question_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        question = Questions.get_question!(question_id)
        district = Districts.get_district!(district_id)

        render(conn, "new.html", changeset: changeset, question: question, district: district)
    end
  end

  def edit(conn, %{"id" => id, "district_id" => district_id, "question_id" => question_id}) do
    district = Districts.get_district!(district_id)
    question = Questions.get_question!(question_id)
    questions = Questions.list_questions()
    choice = Choices.get_choice!(id)

    changeset = Choices.change_choice(choice)

    render(conn, "edit.html",
      changeset: changeset,
      district: district,
      question: question,
      choice: choice,
      questions: questions
    )
  end

  def update(conn, %{
        "id" => id,
        "district_id" => district_id,
        "question_id" => question_id,
        "choice" => choice_params
      }) do
    choice_params = Map.merge(choice_params, %{"question_id" => question_id})
    choice = Choices.get_choice!(id)

    case Choices.update_choice(choice, choice_params) do
      {:ok, _choice} ->
        conn
        |> put_flash(:info, "Choice updated successfully.")
        |> redirect(to: Routes.choice_path(conn, :index, district_id, question_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        question = Questions.get_question!(question_id)
        district = Districts.get_district!(district_id)
        questions = Questions.list_questions()

        render(conn, "edit.html",
          changeset: changeset,
          district: district,
          question: question,
          choice: choice,
          questions: questions
        )
    end
  end

  def delete(conn, %{"id" => id, "district_id" => district_id, "question_id" => question_id}) do
    choice = Choices.get_choice!(id)
    {:ok, _choice} = Choices.delete_choice(choice)

    conn
    |> put_flash(:info, "Choice deleted successfully.")
    |> redirect(to: Routes.choice_path(conn, :index, district_id, question_id))
  end
end
