module AreasHelper
    def load_provinces
      file_path = Rails.root.join('/app/public/', 'areas.json')
      file = File.read(file_path)
      data = JSON.parse(file)
    
      # Directly filtering to return only the label "Sevilla" if it exists in any of the province entries
      provinces = data.flat_map { |item| item['provinces'] }.select { |province| province['label'] == "Sevilla" }.map { |province| province['label'] }
    
      provinces
    end
    

    def load_towns
      file_path = Rails.root.join('/app/public/', 'areas.json')
      file = File.read(file_path)
      data = JSON.parse(file)
    
      # Ensure the selected_province is "Sevilla" for the condition
      selected_province = "Sevilla" # This line ensures that only towns in "Sevilla" are returned
    
      towns = data.flat_map do |item|
        item['provinces'].select { |province| province['label'] == selected_province }.flat_map do |province|
          province['towns'].map { |town| town['label'] }
        end
      end
    
      towns
    end
    
  end
  