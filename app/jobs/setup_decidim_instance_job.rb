class SetupDecidimInstanceJob < ApplicationJob
  queue_as :setup_instance

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

    Dir.chdir('/app/instances')

    # Create and setup the new decidim app
    system("git clone https://github.com/rharana/ingoverkno_decidim_model.git #{instance.name}")
    
    Dir.chdir(instance.name)
    system('yarn install')

    system("sed -i 's/-p 3000/-p #{instance.port}/' Procfile.dev")
    system("echo \"USERNAME=ingoverkno\nPASSWORD=ingoverkno\nINSTANCE_ID=#{instance.id}\nINSTANCE_NAME=#{instance.name}\nINSTANCE_POPULATION=#{instance.population}\" >> .env")
    system("printf \"gem 'tzinfo-data'\ngem 'foreman'\ngem 'decidim-proposals'\ngem 'decidim-sortitions'\ngem 'dotenv-rails'\" >> Gemfile")

    Dir.chdir('config')
    system("sed -i 's/port: 3035/port: #{instance.shakapacker_port}/' shakapacker.yml")
    system("cp /app/public/uploads/banners/#{instance.name}.jpg /app/instances/#{instance.name}/app/packs/images/#{instance.name}_banner.jpg")

    Dir.chdir("/app/instances/#{instance.name}")
    system("rails db:seed")
    # Update the instance's status after successful setup
    instance.update!(status: 'shut')

    Rails.logger.info "Instance creation for #{instance.name} completed successfully and status updated to shut."
  rescue => e
    Rails.logger.error "Failed to create instance: #{e.message}"
    instance.update!(status: 'error')  # Optional: mark status as error if setup fails
    raise e
  end
end