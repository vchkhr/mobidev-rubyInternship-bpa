# frozen_string_literal: true

require 'hanami/router'

app_files = File.expand_path('controllers/*.rb', __dir__)
Dir.glob(app_files).each { |file| require(file) }

app = Hanami::Router.new do
  get   '/',          to: Index.new
  get   '/delete',    to: Delete.new
  get   '/upload',    to: Upload.new
  post  '/upload',    to: Upload.new
  get   '/uploaded',  to: Uploaded.new
end

run app
