defmodule Yak.Worker.Notification do
  # use Que.Worker
  use Toniq.Worker
  import Yak.Web.Router.Helpers
  alias Yak.Board

  @from "Yak <podpora@yak.sk>"
  @reply_to "Adam Gavlák <adam@yak.sk>"

  @template_ids %{
    confirmation: 2045901
  }

  def perform(template: :confirmation, job: job, conn: conn) do
    data = prepare_data(:confirmation, job.email, %{
      title: job.title, 
      link: job_url(conn, :show, job),
      edit_link: job_url(conn, :edit, job.token)
    })
    
    case send(data) do
      {:ok, %HTTPoison.Response{body: body}} -> 
        body = Poison.decode!(body)

        Board.create_notification(%{
          job_id: job.id,
          message_id: body["MessageID"],
          submitted_at: body["SubmittedAt"],
          error_code: body["ErrorCode"],
          message: body["Message"]
        })
      _ ->
        Board.create_notification(%{
          job_id: job.id,
          error_code: 500,
          message: "Request failed"
        }) 
    end
  end

  defp prepare_data(template, email, model) do
    %{
      From: @from,
      To: email,
      ReplyTo: @reply_to,
      Tag: template |> Atom.to_string() |> String.capitalize(),
      TemplateId: @template_ids[template],
      TemplateModel: model
    }
  end
  
  defp send(data) do
    HTTPoison.post(
      "https://api.postmarkapp.com/email/withTemplate",
      Poison.encode!(data),
      [{"Accept", "application/json"}, {"Content-Type", "application/json"}, {"X-Postmark-Server-Token", System.get_env("POSTMARK_API_KEY")}]
    )
  end
end