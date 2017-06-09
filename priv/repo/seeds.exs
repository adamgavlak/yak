# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Yak.Repo.insert!(%Yak.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Yak.Repo
alias Yak.Board

Repo.insert!(%Board.Category{name: "Programovanie", emoji: "⌨️", permalink: "programovanie", lokal: "programovaní"})
Repo.insert!(%Board.Category{name: "Dizajn", emoji: "🖌", permalink: "dizajn", lokal: "dizajne"})
Repo.insert!(%Board.Category{name: "Ostatné", emoji: "📦", permalink: "ostatne", lokal: "ostatných"})

alias FakerElixir, as: Faker

n = 12

# Enum.each(1..3, fn(c) ->
  Enum.each(1..n, fn(n) ->
      el = %{
        title: Faker.Name.title,
        category_id: 1,
        location: Faker.Address.city,
        company: Faker.App.name,
        email: Faker.Internet.email,
        description: Faker.Lorem.sentences(10),
        description_formatted: Faker.Lorem.sentences(10),
        instructions: Faker.Lorem.sentences(1),
      }

      Task.start(fn -> 
        {:ok, job} = Board.create_job(el) 
        Board.approve_job(job)
      end)

      IO.puts "Task to add job #{n} started"
  end)
# end)