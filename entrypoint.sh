#!/bin/bash
# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid
echo "Running migrations..."
bin/rails db:migrate RAILS_ENV=development
bin/shakapacker
# Start the Rails server
echo "Starting Rails server..."
exec "$@"
