class StartDecidimInstanceJob < ApplicationJob
  queue_as :start_instance

  def perform(instance_id)
    instance = Instance.find(instance_id)

    system("supervisorctl reread")
    system("supervisorctl update")
    system("supervisorctl start decidim-#{instance.name}")

    instance.update!(status: 'running')
    Rails.logger.info "Instance start for #{instance.name} completed successfully and status updated to running."
  rescue => e
    Rails.logger.error "Failed to start instance: #{e.message}"
    instance.update!(status: 'error')
    raise e
  end
end
