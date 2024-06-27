# app/repositories/instance_repository.rb
class InstanceRepository
    def all
      Instance.all
    end
  
    def find(id)
      Instance.find_by(id: id)
    end
  
    def save(instance)
      instance.save
    end
  
    def update(instance, params)
      instance.update(params)
    end
  
    def build_instance(params)
      instance = Instance.new(params)
      instance.build_feature_model
      instance
    end
end