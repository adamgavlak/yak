defmodule Yak.Board do

  import Ecto.{Query, Changeset}, warn: false
  import Yak.Web.Router.Helpers
  import Algolia
  
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
  ## Remove status in production

  @required_job_attrs ~w(
    title
    category_id
    location
    instructions
    description
    description_formatted
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
    |> Repo.preload(:category)
  end

  def get_job_by!(attr) do
    Repo.get_by!(Job, attr)
    |> Repo.preload(:category)
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

  ## Job helpers

  def list_categories_public do
    ## Needs improvement 
    # ref - https://elixirforum.com/t/preloading-top-comments-for-posts-in-ecto/1052/8
    
    categories = Repo.all(Category)
    counts = count_categories_jobs()

    Enum.map(categories, fn category -> 
      job_count = case m = Enum.find(counts, fn dbc -> dbc.category_id == category.id end) do
         nil -> 0
         _ -> m.count
      end

      category 
      |> Repo.preload(jobs: from(j in Job, order_by: [desc: j.inserted_at], where: j.status == ^:approved, limit: 8))
      |> Map.put(:job_count, job_count)
    end)
  end

  def count_categories_jobs do
    from(c in Category, left_join: j in Job, on: c.id == j.category_id, where: j.status == ^:approved, group_by: c.id, select: %{category_id: c.id, count: count(j.category_id)})
    |> Repo.all
  end

  def approve_job(%Job{} = job) do
    update_job(job, %{status: :approved})
  end

  def approve_job(id) do
    get_job!(id)
    |> update_job(%{status: :approved})
  end

  def change_job_status(job, status) do
    update_job(job, %{status: status})
  end

  @index "dev_JOBS"
  def index_job(conn, %Job{} = job) do
    Algolia.save_object(@index, 
      %{
        objectID: job.id,
        title: job.title,
        company: job.company,
        location: job.location,
        link: job_url(conn, :show, job),
      })
  end

  ## Categories

  def list_categories do
    Repo.all(Category)
  end

  def get_category_with_jobs(permalink) do
    jobs_query = from(j in Job, where: j.status == ^:approved)
    from(c in Category, where: c.permalink == ^permalink, preload: [jobs: ^jobs_query])
    |> Repo.one()
  end
end
