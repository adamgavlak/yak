defmodule Yak.Web.Router do
  use Yak.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Yak.Web do
    pipe_through :browser # Use the default browser stack

    get "/ponuky", JobController, :index
    get "/", JobController, :index
    post "/ponuky", JobController, :create

    get "/ponuka/nova", JobController, :new
    get "/ponuka/:token/nahlad", JobController, :preview 
    get "/ponuka/:permalink", JobController, :show

    get "/ponuka/:token/upravit", JobController, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", Yak.Web do
  #   pipe_through :api
  # end
end
