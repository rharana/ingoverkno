class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :edit, :update, :destroy, :start, :stop, :status]

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
    if @instance.update(instance_params)
      # If the update is successful, redirect to a specific path, usually the show page for the instance
      redirect_to instances_path, notice: 'Instance was successfully updated.'
    end
  end

  def start
    StartDecidimInstanceJob.perform_later(@instance.id)
    head :ok # Just return OK status
  end

  def status
    render json: { status: @instance.status }
  end

  def stop
    StopDecidimInstanceJob.perform_later(@instance.id)
    head :ok # Just return OK status
  end

  private

  def instance_params
    params.require(:instance).permit(:name, :multi_tenant, :port, :population, :province, :banner, :logo, :status, :shakapacker_port,
    feature_model_attributes: [:proposal, :anonimous_proposal, :participatory_text, :policy_proposal, :survey, :sortition, :citizen_forum,
    :budgeting, :da_support, :km_support, :ir_capability, :transparency, :decision, :meeting, :notification, :debate, :census, :delegation])
  end

  def set_instance
    @instance = Instance.find_by(id: params[:id])
    if @instance.nil?
      render json: { error: "Instance not found" }, status: :not_found
    end
  end

  def destroy
  end

  def show
  end

  def edit
  end


end
