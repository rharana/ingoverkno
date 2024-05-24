class SetupDecidimInstanceJob < ApplicationJob
  queue_as :default

  def perform(instance_id)
    instance = Instance.find(instance_id)
    
    Dir.chdir('instances')

    # Create and setup the new decidim app
    system("decidim #{instance.name}")
    
    Dir.chdir(instance.name)
    system('yarn install')
    system('bin/rails db:create db:migrate')

    system("sed -i 's/-p 3000/-p #{instance.port}/' Procfile.dev")
    
    # Update the instance's status after successful setup
    instance.update!(status: 'shut')

    Rails.logger.info "Instance creation for #{instance.name} completed successfully and status updated to shut."
  rescue => e
    Rails.logger.error "Failed to create instance: #{e.message}"
    instance.update!(status: 'error')  # Optional: mark status as error if setup fails
    raise e
  end
end