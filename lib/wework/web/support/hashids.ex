defmodule Wework.Hashids do
    
  @alphabet "01234567890abcdef"
  @salt Application.get_env(:wework, :hashids_secret_key)
  @h Hashids.new(salt: @salt, min_len: 8, alphabet: @alphabet)

  def encode(id) do
      Hashids.encode(@h, id)
  end

  def decode!(hashid) do
      [id] = Hashids.decode!(@h, hashid)
      id
  end
end
