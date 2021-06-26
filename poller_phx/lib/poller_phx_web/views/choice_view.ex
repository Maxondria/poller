defmodule PollerPhxWeb.ChoiceView do
  use PollerPhxWeb, :view

  alias PollerDal.Choices

  defdelegate parties, to: Choices

  defdelegate party_description(id), to: Choices
end
