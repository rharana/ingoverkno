# app/controllers/instances_controller.rb
class InstancesController < ApplicationController
  before_action :setup_service
  before_action :set_instance, only: [:update, :start, :show, :edit, :destroy, :stop, :status]

  def index
    @instances = @service.list_instances
  end

  def new
    # Initialize a new instance with empty or default parameters
    @instance = @service.build_instance({})
  end

  def create
    files = { banner: params[:instance][:banner], logo: params[:instance][:logo] }
    success, @instance = @service.create_instance(instance_params, files)
    if success
      redirect_to instances_path, notice: 'Instance creation initiated. Setup will complete in the background.'
    else
      render :new
    end
  end

  def update
    success, @instance = @service.update_instance(params[:id], instance_params)
    if success
      redirect_to instances_path, notice: 'Instance was successfully updated.'
    else
      render :edit
    end
  end

  def start
    @service.start_instance(params[:id])
    head :ok
  end

  def status
    @status = @service.instance_status(params[:id])
    render json: { status: @status }
  end

  def stop
    @service.stop_instance(params[:id])
    head :ok
  end

  def destroy
    @service.destroy_instance(params[:id])
    head :ok
  end


  private

  def setup_service
    instance_repository = InstanceRepository.new
    file_storage_adapter = FileStorageAdapter.new
    job_scheduler_adapter = JobSchedulerAdapter.new
    @service = InstanceManagementService.new(instance_repository, file_storage_adapter, job_scheduler_adapter)
  end

  def set_instance
    @instance = @service.find_instance(params[:id])
    if @instance.nil?
      render json: { error: "Instance not found" }, status: :not_found
    end
  end

  def instance_params
    params.require(:instance).permit(:name, :multi_tenant, :port, :population, :province, :status, :shakapacker_port,
    feature_model_attributes: [:proposal, :anonimous_proposal, :participatory_text, :policy_proposal, :survey, :sortition, :citizen_forum,
    :budgeting, :da_support, :km_support, :ir_capability, :transparency, :decision, :meeting, :notification, :debate, :census, :delegation])
  end
end
