# app/adapters/job_scheduler_adapter.rb
class JobSchedulerAdapter
    def enqueue_setup_job(instance_id)
      SetupDecidimInstanceJob.perform_later(instance_id)
    end
  
    def enqueue_start_job(instance_id)
      StartDecidimInstanceJob.perform_later(instance_id)
    end
  
    def enqueue_stop_job(instance_id)
      StopDecidimInstanceJob.perform_later(instance_id)
    end

    def enqueue_destroy_job(instance_id)
      DeleteDecidimInstanceJob.perform_later(instance_id)
    end
end
  