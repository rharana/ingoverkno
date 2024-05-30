class SetupDecidimInstanceJob < ApplicationJob
  queue_as :default

  def perform(instance_id)
    instance = Instance.find(instance_id)
    
    command = <<~COMMAND
      printf "\n[program:decidim-#{instance.name}]\n\
      command=/root/.rbenv/shims/bundle exec bin/dev\n\
      directory=/app/instances/#{instance.name}\n\
      autostart=false\nautorestart=false\n\
      stderr_logfile=/var/log/decidim-#{instance.name}.err.log\n\
      stdout_logfile=/var/log/decidim-#{instance.name}.out.log\n\
      environment=RAILS_ENV='development'\n" >> /etc/supervisor/supervisord.conf
    COMMAND

    system(command)

    Dir.chdir('instances')

    # Create and setup the new decidim app
    system("decidim #{instance.name}")
    
    Dir.chdir(instance.name)
    system('yarn install')

    system("sed -i 's/-p 3000/-p #{instance.port}/' Procfile.dev")
    system("echo \"USERNAME=ingoverkno\nPASSWORD=ingoverkno\" >> .env")
    system("printf \"gem 'tzinfo-data'\ngem 'foreman'\n\" >> Gemfile")

    Dir.chdir('config')
    system("sed -i 's/port: 3035/port: #{instance.shakapacker_port}/' shakapacker.yml")
    system("sed -i 's/database: #{instance.name}_development/database: ingoverkno_development/' database.yml")
    system("rm -rf /app/instances/#{instance.name}/db/migrate")
    # Update the instance's status after successful setup
    instance.update!(status: 'shut')

    Rails.logger.info "Instance creation for #{instance.name} completed successfully and status updated to shut."
  rescue => e
    Rails.logger.error "Failed to create instance: #{e.message}"
    instance.update!(status: 'error')  # Optional: mark status as error if setup fails
    raise e
  end
end