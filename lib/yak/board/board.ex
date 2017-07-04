defmodule Yak.Board do

  import Ecto.{Query, Changeset}, warn: false
  
  alias Yak.Repo
  alias Yak.Board.Category
  alias Yak.Board.Job
  alias Yak.Board.Notification
  alias Yak.Uploader

  @job_attr_whitelist ~w(
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
  )a

  @job_attr_required ~w(
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

  def update_job_extended(%Job{} = job, attrs \\ %{}) do
    job
    |> job_changeset_extended(attrs)
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
    |> cast(attrs, @job_attr_whitelist)
    |> validate_required(@job_attr_required)
    |> Uploader.upload(attrs, "logo")
  end

  defp job_changeset_extended(%Job{} = job, attrs) do
    whitelist = @job_attr_whitelist ++ [:status, :note, :views]

    job
    |> cast(attrs, whitelist)
    |> validate_required(@job_attr_required)
    |> Uploader.upload(attrs, "logo")
  end

  ## Job helpers

  def preload_category(job) do
    Repo.preload(job, :category)
  end

  def list_categories_public do
    ## Needs improvement 
    # ref - https://elixirforum.com/t/preloading-top-comments-for-posts-in-ecto/1052/8
    
    categories = Repo.all(Category)
    counts = count_categories_jobs()

    Enum.map(categories, fn category -> 
      Task.async(fn ->
        job_count = case m = Enum.find(counts, fn dbc -> dbc.category_id == category.id end) do
          nil -> 0
          _ -> m.count
        end

        category 
        |> Repo.preload(jobs: from(j in Job, order_by: [desc: j.inserted_at], where: j.status == ^:active, limit: 8))
        |> Map.put(:job_count, job_count)
      end)
    end)
    |> Enum.map(&Task.await/1)

    # query = """
    #   SELECT board_jobs.* FROM board_categories
    #   JOIN LATERAL (
    #     SELECT * FROM board_jobs
    #     WHERE board_jobs.category_id = board_categories.id
    #     LIMIT 8
    #   ) board_jobs ON true;
    # """

    # result = Ecto.Adapters.SQL.query!(Yak.Repo, query)
    # columns = Enum.map(result.columns, &(String.to_atom(&1)))

    # jobs = Enum.map(result.rows, fn row -> 
    #   struct(Job, Enum.zip(columns, row))
    # end)
    # |> Enum.group_by(&(&1.category_id))
  end

  def count_categories_jobs do
    from(c in Category, left_join: j in Job, on: c.id == j.category_id, where: j.status == ^:active, group_by: c.id, select: %{category_id: c.id, count: count(j.category_id)})
    |> Repo.all
  end

  def change_job_status(job, status) do
    update_job_extended(job, %{status: status})
  end

  def increment_views(job) do
    from(j in Job, where: j.id == ^job.id)
    |> Repo.update_all(inc: [views: 1])
  end

  ## Categories

  def list_categories do
    Repo.all(Category)
  end

  def get_category_with_jobs(permalink) do
    jobs_query = from(j in Job, where: j.status == ^:active)
    from(c in Category, where: c.permalink == ^permalink, preload: [jobs: ^jobs_query])
    |> Repo.one()
  end

  def create_category(attrs) do
    %Category{}
    |> category_changeset(attrs)
    |> Repo.insert()
  end

  defp category_changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name, :permalink, :lokal])
    |> validate_required([:name, :permalink, :lokal])
  end

  ## Notifications

  def list_notifications do
    Repo.all(Notification)
  end

  def create_notification(attrs) do
    %Notification{}
    |> notification_changeset(attrs)
    |> Repo.insert()
  end

  defp notification_changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:job_id, :message_id, :error_code, :message, :submitted_at])
    |> validate_required([:job_id, :error_code, :message])
  end
end
