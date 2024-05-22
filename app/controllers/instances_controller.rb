class InstancesController < ApplicationController
  def new
    @instance = Instance.new
    @instance.build_feature_model
  end

  def create

    @instance = Instance.create(instance_params)
    if @instance.save
      redirect_to @instance, notice: 'Project was successfully created.'
    else
      render :new
    end

    # # Change to the instances directory
    # Dir.chdir('instances')
    
    # # Create and setup the new decidim app
    # system('decidim decidim_instance')
    
    # # Change directory into the new app
    # Dir.chdir('decidim_instance')
    
    # # Install JavaScript dependencies
    # system('yarn install')

    # system('bin/rails db:create db:migrate')

    # logger.info "Instance creation completed successfully"

  end

  private

  def instance_params
    params.require(:instance).permit(:name, :multi_tenant, :port, :population, :province, :banner, :logo)
  end


  def update
  end

  def delete
  end

  def read
  end

  def list
  end
end
