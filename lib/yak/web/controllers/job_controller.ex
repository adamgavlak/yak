defmodule Yak.Web.JobController do
  
  use Yak.Web, :controller

  alias Yak.Board

  def index(conn, _assigns) do
    categories = Board.list_categories_public    
    render(conn, :index, categories: categories)
  end

  def show(conn, %{"permalink" => permalink}) do
    job = Board.get_job!(permalink)
    Toniq.enqueue(Yak.Worker.ViewCount, job)

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
        Toniq.enqueue(Yak.Worker.ChangeStatus, job: job, status: :updated)

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
    
    Toniq.enqueue(Yak.Worker.Notification, template: :confirmation, job: job, conn: conn)
    Toniq.enqueue(Yak.Worker.Index, conn: conn, job: job)
    Toniq.enqueue(Yak.Worker.ChangeStatus, job: job, status: :pending)

    redirect conn, to: job_path(conn, :index), notice: "Ponuka bola vytvorená"
  end
end
