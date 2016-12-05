web: bundle exec passenger start -p $PORT --environment ${RAILS_ENV:-development} --max-pool-size ${MAX_THREADS:-2} --min-instances ${MIN_THREADS:-1}
worker: bundle exec sidekiq
