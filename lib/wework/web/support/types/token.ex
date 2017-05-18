defmodule Wework.Type.Token do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(binary) when is_binary(binary) do
    {:ok, binary}
  end
  def cast(_), do: :error

  def generate() do
    Wework.Random.base16(32)
  end

  def autogenerate, do: generate()

  def load(value) do
    {:ok, value}
  end

  def dump(value) do
    {:ok, value}
  end
end