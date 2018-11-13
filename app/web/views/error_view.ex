defmodule Sense.ErrorView do
  use Sense.Web, :view
  alias Ecto.Changeset

  def render("400.json", _assigns) do
    %{code: 400, error: "Invalid request"}
  end

  def render("401.json", _assigns) do
    %{code: 401, error: "Missing or invalid User"}
  end

  def render("403.json", _assigns) do
    %{code: 403, error: "Access forbidden"}
  end

  def render("404.json", _assigns) do
    %{code: 404, error: "Not found"}
  end

  def render("500.json", _assigns) do
    %{code: 500, error: "Internal server error"}
  end

  def render("error.json", %{changeset: changeset}) do
    Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
