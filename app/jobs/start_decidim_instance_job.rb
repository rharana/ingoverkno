class StartDecidimInstanceJob < ApplicationJob
  queue_as :default

  def perform(instance_id)
    instance = Instance.find(instance_id)
    
    Dir.chdir("instances/#{instance.name}")

    # Create and setup the new decidim app
    system("bin/dev")
    
    instance.update!(status: 'running')

    Rails.logger.info "Instance start for #{instance.name} completed successfully and status updated to running."
  rescue => e
    Rails.logger.error "Failed to start instance: #{e.message}"
    instance.update!(status: 'error')  # Optional: mark status as error if setup fails
    raise e
  end
end
