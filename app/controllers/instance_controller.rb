class InstanceController < ApplicationController
  def new
  end

  def create
    # Change to the instances directory
    Dir.chdir('instances')
    
    # Create and setup the new decidim app
    system('decidim decidim_instance')
    
    # Change directory into the new app
    Dir.chdir('decidim_instance')
    
    # Install JavaScript dependencies
    system('yarn install')

    system('bin/rails db:create db:migrate')

    logger.info "Instance creation completed successfully"

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
