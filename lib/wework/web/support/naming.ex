defmodule Wework.Naming do
  def parameterize(string, opts \\ [extended: false]) do
    if Keyword.fetch!(opts, :extended) do
      string = string
      |> String.replace(~r/\.+/, "dot ")
      |> String.replace(~r/\#+/, " sharp ")
    end

    string
    |> WordSmith.remove_accents()
    |> String.replace(~r/[^\x00-\x7F]+/, "")
    |> String.replace(~r/[^\w]+/, "-")
    |> String.replace(~r/-{2,}/, "-")
    |> String.trim("-")
    |> String.downcase()
  end
end