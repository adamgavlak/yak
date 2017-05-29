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

Repo.insert!(%Board.Category{name: "Programovanie", permalink: "programovanie"})

Board.create_job(%{
  title: "PHP programátor",
  category_id: 1,
  location: "Žilina",
  description: "Bla bla bla",
  description_formatted: "<p>Bla bla bla</p>",
  instructions: "instructions",
  company: "Company s.r.o.",
  url: "https://company.sk",
  email: "email@company.sk"
})
