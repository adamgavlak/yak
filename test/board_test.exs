defmodule Yak.BoardTest do
  use Yak.DataCase

  alias Yak.Board
  alias Yak.Board.Category
  alias Yak.Board.Job

  @create_jobs_attrs %{
    title: "some title",
    location: "some location",
    description: "some description",
    description_formatted: "some formatted description",
    instructions: "some instructions",
    company: "some company",
    url: "some url",
    email: "some email"
  }

  @update_job_attrs %{
    title: "some updated title",
    location: "some updated location",
    description: "some updated description",
    description_formatted: "some updated formatted description",
    instructions: "some updated instructions",
    company: "some updated company",
    url: "some updated url",
    email: "some updated email"
  }

  def fixture(name, attrs \\ %{})
  def fixture(:job, attrs) do
    {:ok, job} = Board.create_job(Map.merge(@create_jobs_attrs, attrs))
    job
  end
  def fixture(:category, _attrs) do
    {:ok, category} = Repo.insert(%Category{name: "Programovanie", permalink: "programovanie"})
    category
  end

  test "get_job! returns job with given id" do
    category = fixture(:category)
    job = fixture(:job, %{category_id: category.id})
    assert Board.get_job!(job.id) == job
  end
  
  test "list_jobs returns all jobs" do
    category = fixture(:category)
    job = fixture(:job, %{category_id: category.id})

    assert Board.list_jobs == [job]
  end

  test "create_job with valid data creates a job" do
    category = fixture(:category)

    assert {:ok, %Job{} = job} = Board.create_job(Map.merge(@create_jobs_attrs, %{category_id: category.id}))
    refute job.token == nil
  end

  test "update_job with valid data updates job" do
    category = fixture(:category)
    job = fixture(:job, %{category_id: category.id})

    assert {:ok, job} = Board.update_job(job, @update_job_attrs)
    assert job.title == "some updated title"
  end

  test "delete_job deletes the job" do
    category = fixture(:category)
    job = fixture(:job, %{category_id: category.id})

    assert {:ok, %Job{}} = Board.delete_job(job)
    assert_raise Ecto.NoResultsError, fn -> Board.get_job!(job.id) end
  end
end
