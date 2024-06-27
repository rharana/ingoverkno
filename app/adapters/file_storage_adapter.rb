# app/adapters/file_storage_adapter.rb
class FileStorageAdapter
    def save_files(instance, files)
        save_file(instance, files[:banner], 'banners')
        save_file(instance, files[:logo], 'logos')
    end

    private
  
    def save_file(instance, uploaded_file, folder)
        directory = Rails.root.join('public', 'uploads', folder)
        FileUtils.mkdir_p(directory) unless File.exist?(directory)
        path = File.join(directory, "#{instance.name}.jpg")
        File.open(path, 'wb') do |file|
            file.write(uploaded_file.read)
        end
        path
    end
end