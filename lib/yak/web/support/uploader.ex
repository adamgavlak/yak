defmodule Yak.Uploader do

  alias ExAws, as: Aws

  @bucket "yak-dev"

  def upload(struct, attrs, field) do
    image = attrs[field]

    case image do
      nil ->
        struct
      _ ->
        filename = Yak.Random.base16(24)
        url = "/#{field}s/#{filename}.png"

        path = image.path <> "-converted"
        System.cmd("convert", [image.path, "-resize", "190x190", "-format", "png", path])

        Aws.S3.put_object(@bucket, url, File.read!(path), content_type: "image/png")
        |> Aws.request

        Ecto.Changeset.put_change(struct, :logo, url)
    end
  end
end
