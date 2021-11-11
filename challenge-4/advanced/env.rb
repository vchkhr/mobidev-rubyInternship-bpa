# frozen_string_literal: true

# Data for database connection
module Env
  def read_env
    @dbname = 'bpa'
    @user = 'postgres'
    @password = 'pass'
  end
end
