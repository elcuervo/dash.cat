require "cuba"
require "cuba/sugar/routes"
require "dalli"
require "rack/cache"

ENV["MEMCACHE_SERVERS"]  = ENV["MEMCACHIER_SERVERS"]  if ENV["MEMCACHIER_SERVERS"]
ENV["MEMCACHE_USERNAME"] = ENV["MEMCACHIER_USERNAME"] if ENV["MEMCACHIER_USERNAME"]
ENV["MEMCACHE_PASSWORD"] = ENV["MEMCACHIER_PASSWORD"] if ENV["MEMCACHIER_PASSWORD"]


class DashCat < Cuba
  dalli = Dalli::Client.new

  plugin Cuba::Sugar::Routes

  use Rack::Cache, {
    verbose:     true,
    metastore:   dalli,
    entitystore: dalli
  }

  define do
    on subdomain("track"), get do
      run Rack::Static.new @app, urls: [""], root: '.', index: 'tracker.html'
    end

    on default, get do
      run Rack::Static.new @app, urls: [""], root: '.', index: 'index.html'
    end
  end
end

run DashCat
