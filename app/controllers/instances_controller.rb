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
      paths = save_files(@instance, params[:instance][:banner], params[:instance][:logo])
      @organization = DecidimOrganization.new(
        name: @instance.population,
        host: "#{@instance.name}.localhost",
        default_locale: "es",
        available_locales: ['en', 'es', 'fr'],  # default value, considered required for functionality
        created_at: Time.now,
        updated_at: Time.now,
        description: { "es": "Ayuntamiento de #{@instance.population}" },
        reference_prefix: "ORG",
        secondary_hosts: [],
        available_authorizations: [],
        id_documents_methods: ['online'],
        id_documents_explanation_text: {},
        colors: {},
        logo: paths[:logo_url],
        highlighted_content_banner_enabled: true,
        highlighted_content_banner_title: { "es": "¡Bienvenido al ayuntamiento de #{@instance.population}!" },
        highlighted_content_banner_short_description: { "es": "Únete a nuestra plataforma democrática" },
        highlighted_content_banner_image: paths[:banner_url],
        smtp_settings: {},
        omniauth_settings: {},
        admin_terms_of_service_body: {},
        content_security_policy: {},
        file_upload_settings: {},
        time_zone: "UTC",
        external_domain_whitelist: [],
        enable_participatory_space_filters: true
      )
      @organization.save
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

  def save_files(instance, banner_file, logo_file)
    paths = {}
    paths[:banner_url] = save_file(banner_file, 'banners') if banner_file
    paths[:logo_url] = save_file(logo_file, 'logos') if logo_file
    paths
  end

  def save_file(uploaded_file, folder)
    filename = SecureRandom.uuid + File.extname(uploaded_file.original_filename)
    directory = Rails.root.join('public', 'uploads', folder)
    FileUtils.mkdir_p(directory) unless File.exist?(directory)
    path = File.join(directory, filename)
    File.open(path, 'wb') do |file|
      file.write(uploaded_file.read)
    end
    path
  end

  def destroy
  end

  def show
  end

  def edit
  end


end
