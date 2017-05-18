defmodule Wework.Hashids do
    
  @alphabet "0123456789abcdefghijklmnopqrstuvwxyz"
  @hashids Hashids.new([salt: Application.get_env(:jobs, :hashids_secret_key, "secret"), min_len: 4, alphabet: @alphabet])

  def encode(id) do
      Hashids.encode(@hashids, id)
  end

  def decode!(hashid) do
      [id] = Hashids.decode!(@hashids, hashid)
      id
  end
end
