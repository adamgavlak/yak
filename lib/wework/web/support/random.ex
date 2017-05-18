defmodule Wework.Random do
  
  @default_length 4
  
  def base16(length \\ @default_length) do
    gen = random_bytes(length)
    |> Base.encode16(case: :lower)
    |> String.slice(0..length - 1)
  end

  def base32(length \\ @default_length) do
    gen = random_bytes(length)
    |> Base.encode32(case: :lower)
    |> String.slice(0..length - 1)
  end

  defp random_bytes(n \\ @default_length) do
    :crypto.strong_rand_bytes(n)
  end
end