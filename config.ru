require "cuba"
require "cuba/sugar/routes"
require "cuba/render"
require "dalli"
require "rack/cache"

ENV["MEMCACHE_SERVERS"]  = ENV["MEMCACHIER_SERVERS"]  if ENV["MEMCACHIER_SERVERS"]
ENV["MEMCACHE_USERNAME"] = ENV["MEMCACHIER_USERNAME"] if ENV["MEMCACHIER_USERNAME"]
ENV["MEMCACHE_PASSWORD"] = ENV["MEMCACHIER_PASSWORD"] if ENV["MEMCACHIER_PASSWORD"]


class DashCat < Cuba
  dalli = Dalli::Client.new

  plugin Cuba::Sugar::Routes
  plugin Cuba::Render

  use Rack::Cache, {
    verbose:     true,
    metastore:   dalli,
    entitystore: dalli
  }

  define do
    on subdomain("track"), get do
      run Rack::Static.new @app, urls: [""], root: '.', index: 'tracker.html'
    end

    on root do
      res.write view("home")
    end

    on "ct" do
      res.write view("home_ct")
    end

    on "about" do
      res.write view("about")
    end

    on default, get do
      run Rack::Static.new @app, urls: [""], root: 'public'
    end
  end
end

run DashCat
