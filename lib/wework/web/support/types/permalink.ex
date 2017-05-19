defmodule Wework.Type.Permalink do
  @behaviour Ecto.Type

  def type, do: :id

  def cast(binary) when is_binary(binary) do
    case Regex.run(~r/([0-9a-z]+)\-/, binary) do
      [_, hashid] ->
        {:ok, Wework.Hashids.decode!(hashid)}
      _ ->
        :error
    end
  end

  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def cast(_), do: :error

  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end

end
