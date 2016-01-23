class Item
  include Dynamoid::Document

  table name: :sensor_data, key: :key, :read_capacity => 5, :write_capacity => 5

  field :timestamp, :integer
  field :payload, :serialized

  def self.chart_values
    x_data = []
    temperatures = []
    humidities = []
    soil_moistures = []

    # not an efective way to do
    Item.all.each do |item|
      x_data << item.timestamp
      temperatures << (item.payload['temp'].to_f || 0)
      humidities << (item.payload['hum'].to_f || 0)
      soil_moistures << (item.payload['sol'].to_f || 0)
    end
    highcharts_value(x_data, temperatures, humidities, soil_moistures)
  end

  def self.highcharts_value(x_axis, temp, hum, soil)
    {
      xData: x_axis,
      datasets: [
        {
          name: 'Temperature',
          data: temp,
          unit: '°C',
          type: 'area',
          valueDecimals: 1
        },
        {
          name: 'Humidity',
          data: hum,
          unit: '%',
          type: 'area',
          valueDecimals: 1
        },
        {
          name: 'Soil Moisture',
          data: soil,
          unit: '',
          type: 'area',
          valueDecimals: 0
        }
      ]
    }
  end
end
