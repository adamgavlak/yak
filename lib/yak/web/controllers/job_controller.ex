defmodule Yak.Web.JobController do
  
  use Yak.Web, :controller

  alias Yak.Board

  def index(conn, _assigns) do
    categories = Board.list_categories_public    
    render(conn, :index, categories: categories)
  end

  def show(conn, %{"permalink" => permalink}) do
    job = Board.get_job!(permalink)
    render conn, :show, job: job
  end

  def new(conn, _assigns) do
    render(conn, :new, 
      changeset: Board.change_job(%Board.Job{}),
      categories: Board.list_categories())
  end

  def create(conn, %{"job" => job_params}) do
    case Board.create_job(job_params) do
      {:ok, job} ->
        if Mix.env == :prod do
          

          ## TODO: Index new job
          # Indexuj ponuku az potom ako ju admin potvrdi
          # Task.start(fn -> Board.index_job(conn, job) end)
        end
        

        redirect conn, to: job_path(conn, :preview, job.token)
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, :new, changeset: changeset, categories: Board.list_categories()
    end
  end

  def edit(conn, %{"token" => token}) do
    job = Board.get_job_by! token: token

    render(conn, :edit, 
      changeset: Board.change_job(job),
      categories: Board.Category.Store.list())
  end

  def update(conn, %{"token" => token, "job" => job_params}) do
    job = Board.get_job_by!(token: token)

    case Board.update_job(job, job_params) do
      {:ok, job} ->
        Board.change_job_status(job, :updated)

        redirect conn, to: job_path(conn, :preview, job.token)
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, :edit, changeset: changeset, categories: Board.Category.Store.list()
    end
  end

  def preview(conn, %{"token" => token}) do
    job = Board.get_job_by!(token: token)
    render conn, :preview, job: job
  end

  def confirm(conn, %{"token" => token}) do
    job = Board.get_job_by!(token: token)
    
    ## Posli email s potvrdenim, ze ponuka je ulozena
    Postmark.deliver(:confirmation, job.email, %{
            title: job.title,
            link: job_url(conn, :show, job),
            edit_link: job_url(conn, :edit, job.token)
    })

    Board.change_job_status(job, :waiting)

    redirect conn, to: job_path(conn, :index), notice: "Ponuka bola vytvorena"
  end
end
