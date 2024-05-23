class InstancesController < ApplicationController
  def index
    @instances = Instance.all
  end
  
  def new
    @instance = Instance.new
    @instance.build_feature_model
  end

  def create

    @instance = Instance.new(instance_params)
    if(@instance.save)
      SetupDecidimInstanceJob.perform_later(@instance.id)
      redirect_to instances_path, notice: 'Instance creation initiated. Setup will complete in the background.'
    else
      # If the instance fails to save, re-render the 'new' form
      render :new
    end
  end

  def update
    @instance = Instance.find(params[:id])
    if @instance.update(instance_params)
      # If the update is successful, redirect to a specific path, usually the show page for the instance
      redirect_to instances_path, notice: 'Instance was successfully updated.'
    end
  end

  private

  def instance_params
    params.require(:instance).permit(:name, :multi_tenant, :port, :population, :province, :banner, :logo, :status,
    feature_model_attributes: [:proposal, :anonimous_proposal, :participatory_text, :policy_proposal, :survey, :sortition, :citizen_forum,
    :budgeting, :da_support, :km_support, :ir_capability, :transparency, :decision, :meeting, :notification, :debate, :census, :delegation])
  end

  def destroy
  end

  def show
  end


end
