class StartDecidimInstanceJob < ApplicationJob
  queue_as :default

  def perform(instance_id)
    instance = Instance.find(instance_id)

    system("systemctl daemon-reload")
    system("systemctl restart decidim@#{instance.name}")

    instance.update!(status: 'running')
    Rails.logger.info "Instance start for #{instance.name} completed successfully and status updated to running."
  rescue => e
    Rails.logger.error "Failed to start instance: #{e.message}"
    instance.update!(status: 'error')
    raise e
  end
end