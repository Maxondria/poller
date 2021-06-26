defmodule PollerPhxWeb.Api.QuestionView do
  use PollerPhxWeb, :view
  alias __MODULE__

  def render("index.json", %{questions: questions}) do
    render_many(questions, QuestionView, "show.json")
  end

  def render("show.json", %{question: question}) do
    %{
      description: question.description,
      district_id: question.district_id,
      id: question.id
    }
  end
end
