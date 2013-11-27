require 'resque/server'

module Resque
  module Plugins
    module BatchedJob
      module Server
        def self.erb_path(filename)
          File.join(File.dirname(__FILE__), 'server', 'views', filename)
        end

        def self.registered(app)
          app.get '/index' do
            erb File.read(Resque::Plugins::BatchedJob::Server.erb_path('index.html.erb'))
          end

          app.get '/show/:batch_id' do
            @jobs = Resque::Plugins::BatchedJob.batched_jobs(params[:batch_id])
            erb File.read(Resque::Plugins::BatchedJob::Server.erb_path('show.html.erb'))
          end
        end
      end
    end
  end
end

Resque::Server.class_eval do
  register Resque::Plugins::BatchedJob::Server
  tabs << 'Batchs'
end
