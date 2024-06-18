instance_id = ENV['INSTANCE_ID']
instance_name = ENV['INSTANCE_NAME']
instance_population = ENV['INSTANCE_POPULATION']

organization = Decidim::Organization.new(
    name: instance_population,
    host: "#{instance_name}.localhost",
    default_locale: "es",
    available_locales: ['en', 'es', 'fr'],  # default value, considered required for functionality
    created_at: Time.now,
    updated_at: Time.now,
    description: { "es": "Ayuntamiento de #{instance_population}" },
    reference_prefix: "ORG",
    secondary_hosts: [],
    available_authorizations: [],
    id_documents_methods: ['online'],
    id_documents_explanation_text: {},
    colors: {},
    smtp_settings: {},
    omniauth_settings: {},
    admin_terms_of_service_body: {},
    content_security_policy: {},
    file_upload_settings: {},
    time_zone: "UTC",
    external_domain_whitelist: [],
    enable_participatory_space_filters: true
)

organization.save

content_block = Decidim::ContentBlock.create!(
  decidim_organization_id: organization.id,
  scope_name: 'homepage',
  manifest_name: 'hero',
  weight: 10,
  published_at: Time.current
)

# Correct the path to the image
image_path = Rails.root.join("app", "packs", "images", "#{instance_name}_banner.jpg")

# Ensure the file exists
if File.exist?(image_path)
  # Attach the image using the images_container method
  content_block.images_container.background_image = {
    io: File.open(image_path),
    filename: "#{instance_name}_banner.jpg",
    content_type: 'image/jpeg' # or the correct MIME type
  }

  # Save the content block along with the attachment
  if content_block.save!
    puts "Content block saved successfully with the image."
  else
    puts "Failed to save the content block."
  end
else
  puts "File does not exist at #{image_path}"
end
