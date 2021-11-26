# frozen_string_literal: true

require 'hanami/router'

require_relative './controllers/index'
require_relative './controllers/delete'
require_relative './controllers/upload'
require_relative './controllers/uploaded'

require_relative './controllers/reports/states'
require_relative './controllers/reports/fixture_types'
require_relative './controllers/reports/costs'

app = Hanami::Router.new do
  get   '/',                                  to: Index.new

  get   '/delete',                            to: Delete.new
  get   '/upload',                            to: Upload.new
  post  '/upload',                            to: Upload.new
  get   '/uploaded',                          to: Uploaded.new

  get   '/reports/states',                    to: StatesReport.new
  get   '/reports/states/:id',                to: StatesReport.new

  get   '/reports/offices/fixture_types',     to: FixtureTypesReport.new
  get   '/reports/offices/:id/fixture_types', to: FixtureTypesReport.new

  get   '/reports/costs',                     to: CostsReport.new
end

run app
