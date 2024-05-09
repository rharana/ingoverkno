class InstancesController < ApplicationController
  def new
    @instance = Instance.new
  end

  def create

    @instance = Instance.create(
      name: params[:instance][:name],
      multi_tenant: params[:instance][:multi_tenant],
      port: params[:instance][:port],
      population: params[:instance][:population],
      province: params[:instance][:province],
      banner_url: params[:instance][:banner_url],
      logo_url: params[:instance][:logo_url])
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

  def update
  end

  def delete
  end

  def read
  end

  def list
  end
end
