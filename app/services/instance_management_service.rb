# app/services/instance_management_service.rb
class InstanceManagementService
    def initialize(instance_repository, file_storage_adapter, job_scheduler_adapter)
        @instance_repository = instance_repository
        @file_storage = file_storage_adapter
        @job_scheduler = job_scheduler_adapter
    end
  
    def list_instances
        @instance_repository.all
    end
  
    def find_instance(id)
        @instance_repository.find(id)
    end

    def build_instance(params)
        @instance_repository.build_instance(params)
    end
  
    def create_instance(params, files)
        instance = @instance_repository.build_instance(params)
        if @instance_repository.save(instance)
            @file_storage.save_files(instance, files)
            @job_scheduler.enqueue_setup_job(instance.id)
            [true, instance]
        else
            [false, instance]
        end
    end
  
    def update_instance(id, params)
        instance = @instance_repository.find(id)
        if @instance_repository.update(instance, params)
            [true, instance]
        else
            [false, instance]
        end
    end
  
    def start_instance(id)
        @job_scheduler.enqueue_start_job(id)
    end
  
    def stop_instance(id)
        @job_scheduler.enqueue_stop_job(id)
    end
  
    def instance_status(id)
        instance = @instance_repository.find(id)
        instance&.status
    end
end
  