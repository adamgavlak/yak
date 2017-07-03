defmodule Yak.Web.JobControllerTest do
  use Yak.Web.ConnCase

  alias Yak.Board

  @create_attrs %{
    title: "some title",
    location: "some location",
    description: "some description",
    description_formatted: "some formatted description",
    instructions: "some instructions",
    company: "some company",
    url: "some url",
    email: "some email" 
  }

  @update_attrs %{
    title: "some updated title",
    location: "some updated location",
    description: "some updated description",
    description_formatted: "some updated formatted description",
    instructions: "some updated instructions",
    company: "some updated company",
    url: "some updated url",
    email: "some updated email" 
  }

  @invalid_attrs %{
    title: nil,
    location: nil,
    description: nil,
    description_formatted: nil,
    instructions: nil,
    company: nil,
    url: nil,
    email: nil 
  }

  @category_attrs %{
    name: "some category", 
    permalink: "some-category", 
    lokal: "some category"
  }

  def fixture(:category) do
    {:ok, category} = Board.create_category(@category_attrs)
  end

  def fixture(:job) do
    {:ok, category} = fixture(:category)
    {:ok, job} = Board.create_job(Map.merge(@create_attrs, %{category_id: category.id}))
  end

  test "lists 8 latest jobs from each category" do

  end

  test "renders form for new job", %{conn: conn} do
    conn = get conn, job_path(conn, :new)
    assert html_response(conn, 200) =~ "Nová ponuka"
  end

  test "creates job and redirects to show when data is valid", %{conn: conn} do
    {:ok, category} = fixture(:category)
    conn = post conn, job_path(conn, :create), job: Map.put(@create_attrs, :category_id, category.id)

    assert %{token: token} = redirected_params(conn)
    assert redirected_to(conn) == job_path(conn, :preview, token)

    conn = get conn, job_path(conn, :preview, token)
    assert html_response(conn, 200) =~ "Náhľad ponuky"
  end

  test "does not create job and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, job_path(conn, :create), job: @invalid_attrs
    assert html_response(conn, 200) =~ "Nová ponuka"
  end

  test "renders form for editing job", %{conn: conn} do
    {:ok, job} = fixture(:job)
    conn = get conn, job_path(conn, :edit, job.token)

    assert html_response(conn, 200) =~ "Upraviť ponuku"
  end

  test "updates job and redirects when data is valid", %{conn: conn} do
    {:ok, job} = fixture(:job)
    {:ok, category} = fixture(:category)
    conn = put conn, job_path(conn, :update, job.token), job: Map.put(@update_attrs, :category_id, category.id)

    assert redirected_to(conn) == job_path(conn, :preview, job.token)

    conn = get conn, job_path(conn, :preview, job.token)
    assert html_response(conn, 200) =~ "Náhľad ponuky"
  end

  test "does not update job and renders errors when data is invalid", %{conn: conn} do
    {:ok, job} = fixture(:job)
    conn = put conn, job_path(conn, :update, job.token), job: @invalid_attrs
    assert html_response(conn, 200) =~ "Upraviť ponuku"
  end
end