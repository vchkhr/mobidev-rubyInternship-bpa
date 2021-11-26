# frozen_string_literal: true

require_relative 'render'
require_relative '../db/db'

DB = Db.new

# Upload CSV file
class Upload
  include Render

  def call(env)
    request = Rack::Request.new(env)

    if request.post?
      file = File.read(request.params['file'][:tempfile])

      DB.connect(file)

      [302, { 'Location' => '/uploaded' }, []]
    else
      render_template 'views/upload.html.erb'
    end
  end
end
