class DeleteDecidimInstanceJob < ApplicationJob
  queue_as :delete_instance

  def perform(instance_id)
    instance = Instance.find(instance_id)
    command = <<~COMMAND
      sed -i '/\\[program:decidim-#{instance.name}\\]/,/^$/d' /etc/supervisor/supervisord.conf
    COMMAND
    system(command)
    Dir.chdir('/app/instances')
    system("rm -rf /app/instances/#{instance.name}")
    instance.destroy
  end
end
