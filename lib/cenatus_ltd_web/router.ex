defmodule CenatusLtdWeb.Router do
  use CenatusLtdWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(CenatusLtdWeb.Auth, repo: CenatusLtd.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", CenatusLtdWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :home)
    get("/login", SessionController, :new)

    get("/creative", PageController, :creative)
    get("/technology", PageController, :technology)
    get("/production", PageController, :production)

    get("/people", PageController, :people)
    get("/about", PageController, :about)
    get("/contact", PageController, :contact)

    get("/rss", FeedController, :index)

    resources("/articles", ArticleController, only: [:show])
    resources("/blog", BlogController, only: [:index, :show])
    resources("/categories", CategoryController, only: [:show])
    resources("/sections", SectionController, only: [:show])
    resources("/sessions", SessionController, only: [:new, :create, :delete])
    resources("/tags", TagController, only: [:show])

    get("/sitemaps/sitemap1.xml", Redirector,
      external: "https://s3.eu-central-1.amazonaws.com/cenatus/sitemap1.xml"
    )

    # Archive redirects
    get("/projects", Redirector, to: "/")
    get("/projects/2", Redirector, to: "/articles/1-sam-cafe-oto-commission")

    get("/projects/8", Redirector,
      external: "https://archive.cenatus.org/production/sonic-ecosystem-by-ollie-bown/"
    )

    # get "/projects/infrasonics/", Redirector, to: "???"
    get("/web-design", Redirector, to: "/technology")

    get("/production/netaudio06-london", Redirector, to: "/articles/3-netaudio-london")

    get("/production/sam-cafe-oto-commission/", Redirector,
      to: "/articles/1-sam-cafe-oto-commission"
    )

    get("/search/by-tag/production", Redirector, to: "/production")
    get("/search/by-tag/WebDesign", Redirector, to: "/technology")
    get("/search/by-tag/MusicTechnology", Redirector, to: "/technology")

    get("/people/matt-spendlove", Redirector, to: "/articles/4-matt-spendlove")

    get("/web-design/freelance/matt-spendlove/", Redirector,
      to: "/articles/8-freelance-creative-technologist"
    )

    get("/people/andi-studer", Redirector,
      external: "https://archive.cenatus.org/people/andi-studer/"
    )

    get("/people/jenna-jones", Redirector,
      external: "https://archive.cenatus.org/people/jenna-jones/"
    )

    get("/people/christoph-guttandin", Redirector,
      external: "https://archive.cenatus.org/people/christoph-guttandin/"
    )

    get("/people/gregor-barth", Redirector,
      external: "https://archive.cenatus.org/people/gregor-barth/"
    )

    get("/people/luca-schiavoni", Redirector,
      external: "https://archive.cenatus.org/people/luca-schiavoni/"
    )
  end

  scope "/admin", CenatusLtdWeb do
    pipe_through([:browser, :authenticate_user])

    get("/", PageController, :admin)

    resources("/articles", ArticleController, except: [:show])
    resources("/categories", CategoryController, except: [:show])
    resources("/sections", SectionController, except: [:show])
    resources("/tags", TagController, except: [:show])
    resources("/users", UserController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CenatusLtdWeb do
  #   pipe_through :api
  # end
end
