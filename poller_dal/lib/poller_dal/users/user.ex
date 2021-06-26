defmodule PollerDal.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @email_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:admin, :boolean)

    timestamps()
  end

  def admin_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:admin])
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, @email_regex)
    |> down_case_email()
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp down_case_email(%Ecto.Changeset{} = changeset) do
    case get_field(changeset, :email) do
      nil -> changeset
      email -> put_change(changeset, :email, String.downcase(email))
    end
  end

  defp put_password_hash(%Ecto.Changeset{} = changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
