defmodule Yak.BoardTest do
  use Yak.DataCase

  alias Yak.Board

  @valid_attrs %{
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

  def job_fixture(attrs \\ %{}) do
    {:ok, job} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Board.create_job()

    job
  end

  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{name: "Some category", permalink: "some-category", lokal: "some category"})
      |> Board.create_category()

    category
  end

  describe "jobs" do
    alias Yak.Board.Job

    test "create_job/1 with valid data creates a job" do
      category = category_fixture()

      attrs = %{category_id: category.id}
      |> Enum.into(@valid_attrs)

      assert {:ok, %Job{} = job} = Board.create_job(attrs)
      assert job.title == "some title"
      assert job.category_id == category.id
      assert job.email == "some email"
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Board.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      old_category = category_fixture()
      job = job_fixture(%{category_id: old_category.id})
      category = category_fixture()

      attrs = %{category_id: category.id}
      |> Enum.into(@update_attrs)

      assert {:ok, job} = Board.update_job(job, attrs)
      assert %Job{} = job
      assert job.title == "some updated title"
      assert job.category_id == category.id
      assert job.email == "some updated email"
    end

    test "update_job/2 with invalid data returns error changeset" do
      old_category = category_fixture()
      job = job_fixture(%{category_id: old_category.id})

      assert {:error, %Ecto.Changeset{}} = Board.update_job(job, @invalid_attrs)
      assert job == Board.get_job!(job.id)
    end

    test "change_job_status/1 changes job status" do
      old_category = category_fixture()
      job = job_fixture(%{category_id: old_category.id})

      assert job.status == :created
      assert {:ok, job} = Board.change_job_status(job, :active)
      assert job.status == :active
    end

    test "increment_views/1 increments views by 1" do
      old_category = category_fixture()
      job = job_fixture(%{category_id: old_category.id})

      assert job.views == 0
      assert {1, nil} = Board.increment_views(job)
      assert Board.get_job!(job.id).views == 1
    end
  end

  describe "notifications" do
    alias Yak.Board.Notification

    @valid_notification_attrs %{
      message_id: "00000000-0000-0000-0000-000000000000",
      error_code: 0,
      message: "OK",
      submitted_at: "2017-01-01 00:00:00.000000"
    }

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_notification_attrs)
        |> Board.create_notification()

      notification
    end

    test "create_notification/1 with valid data creates notification" do
      old_category = category_fixture()
      job = job_fixture(%{category_id: old_category.id})

      attrs = %{job_id: job.id}
      |> Enum.into(@valid_notification_attrs)

      assert {:ok, notification} = Board.create_notification(attrs)
      assert notification.message == "OK"
      assert notification.error_code == 0
      assert notification.message_id == "00000000-0000-0000-0000-000000000000"
    end
  end
end