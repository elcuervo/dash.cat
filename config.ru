require "cuba"
require "cuba/sugar/routes"

Cuba.plugin Cuba::Sugar::Routes
Cuba.define do
  on subdomain("track") do
    run Rack::Static.new @app, urls: [""], root: '.', index: 'tracker.html'
  end

  on default do
    run Rack::Static.new @app, urls: [""], root: '.', index: 'index.html'
  end
end

run Cuba
