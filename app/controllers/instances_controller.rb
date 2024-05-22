class InstancesController < ApplicationController
  def index
    @instances = Instance.all
  end
  
  def new
    @instance = Instance.new
    @instance.build_feature_model
  end

  def create

    @instance = Instance.create(instance_params)
    @instance.status = 0
    render json: @instance

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
    params.require(:instance).permit(:name, :multi_tenant, :port, :population, :province, :banner, :logo,
    feature_model_attributes: [:proposal, :anonimous_proposal, :participatory_text, :policy_proposal, :survey, :sortition, :citizen_forum,
    :budgeting, :da_support, :km_support, :ir_capability, :transparency, :decision, :meeting, :notification, :debate, :census, :delegation])
  end


  def update
  end

  def destroy
  end

  def show
  end


end
