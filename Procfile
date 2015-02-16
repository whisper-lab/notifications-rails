web: bundle exec puma -C config/puma.rb
# DYNO will be set to worker.1, worker.2, etc for each worker process
worker: bundle exec sidekiq -e production -i ${DYNO:-1}
