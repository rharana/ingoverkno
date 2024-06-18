module AreasHelper
    def load_provinces
      file_path = Rails.root.join('/app/public/', 'areas.json')
      file = File.read(file_path)
      data = JSON.parse(file)
      provinces = data.map { |item| item['provinces'].map { |province| province['label'] } }.flatten
      provinces
    end
  end
  