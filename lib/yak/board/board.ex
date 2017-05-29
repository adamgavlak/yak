defmodule Yak.Board do

  import Ecto.{Query, Changeset}, warn: false
  
  alias Yak.Repo
  alias Yak.Board.Category
  alias Yak.Board.Job
  alias Yak.Uploader

  @allowed_job_attrs ~w(
    title
    category_id
    location
    description
    description_formatted
    instructions
    company
    url
    email
    highlight
    status
    note
  )a

  @required_job_attrs ~w(
    title
    category_id
    location
    instructions
    company
    email
    highlight
  )a

  ## Jobs

  def list_jobs do
    Repo.all(Job)
  end

  def get_job!(id) do
    Repo.get!(Job, id)
  end

  def get_job_by!(attr) do
    Repo.get_by!(Job, attr)
  end

  def create_job(attrs \\ %{}) do
    %Job{}
    |> job_changeset(attrs)
    |> Repo.insert()
  end

  def update_job(%Job{} = job, attrs \\ %{}) do
    job
    |> job_changeset(attrs)
    |> Repo.update()
  end

  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  def change_job(%Job{} = job) do
    job_changeset(job, %{})
  end

  defp job_changeset(%Job{} = job, attrs) do
    job
    |> cast(attrs, @allowed_job_attrs)
    |> validate_required(@required_job_attrs)
    |> Uploader.upload(attrs, "logo")
  end

  ## Categories

  def list_categories do
    Repo.all(Category)
  end
end
