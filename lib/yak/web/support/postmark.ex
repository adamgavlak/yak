defmodule Postmark do
  import Logger

  @from "Yak <podpora@yak.sk>"
  @reply_to "Adam Gavlák <adam@yak.sk>"

  @template_ids %{
    confirmation: 2045901
  }
  
  def deliver(template, email, model \\ %{}) do
    data = %{From: @from,
      To: email,
      ReplyTo: @reply_to,
      Tag: template |> Atom.to_string() |> String.capitalize(),
      TemplateId: @template_ids[template],
      TemplateModel: model
    }

    Task.start(fn -> 
      response = HTTPoison.post(
        "https://api.postmarkapp.com/email/withTemplate",
        Poison.encode!(data),
        [{"Accept", "application/json"}, {"Content-Type", "application/json"}, {"X-Postmark-Server-Token", System.get_env("POSTMARK_API_KEY")}]
      )
    end)
  end

end
