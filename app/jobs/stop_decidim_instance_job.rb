class StopDecidimInstanceJob < ApplicationJob
  queue_as :stop_instance

  def perform(instance_id)
    instance = Instance.find(instance_id)

    system("supervisorctl stop decidim-#{instance.name}")

    instance.update!(status: 'shut')
    Rails.logger.info "Instance stop for #{instance.name} completed successfully and status updated to running."
    rescue => e
      Rails.logger.error "Failed to stop instance: #{e.message}"
      instance.update!(status: 'error')
      raise e
    end

end
