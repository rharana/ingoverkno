module AreasHelper
    def load_provinces
      file_path = Rails.root.join('/app/public/', 'areas.json')
      file = File.read(file_path)
      data = JSON.parse(file)
      provinces = data.map { |item| item['provinces'].map { |province| province['label'] } }.flatten
      provinces
    end

    def load_towns(selected_province)
      file_path = Rails.root.join('/app/public/', 'areas.json')
      file = File.read(file_path)
      data = JSON.parse(file)
      towns = data.flat_map do |item|
        item['provinces'].select { |province| province['label'] == selected_province }.flat_map { |province| province['towns'].map { |town| town['label'] } }
      end
    
      towns
    end
    
  end
  