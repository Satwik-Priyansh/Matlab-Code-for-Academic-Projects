# Temperature and Humidity Sensing with MATLAB

This project demonstrates real-time temperature, humidity, and heat index monitoring using a sensor (likely DHT22 or similar) connected to an Arduino board, with data visualization in MATLAB.

## Features

- Real-time temperature, humidity, and heat index measurements
- Continuous data logging and visualization
- Three separate plots for temperature, humidity, and heat index
- Automatic time-based x-axis scaling

## Requirements

- Arduino board with temperature and humidity sensor (e.g., DHT22)
- MATLAB R2019b or later
- Arduino IDE (for uploading code to the Arduino)
- USB cable for connecting Arduino to computer

## Setup Instructions

1. **Arduino Setup**
   - Connect your temperature and humidity sensor to the Arduino board.
   - Upload the appropriate sketch to your Arduino (code not provided in this README).

2. **MATLAB Setup**
   - Ensure you have MATLAB R2019b or later installed.
   - Copy the provided MATLAB script into a new file named `temp_humidity_sensing.m`.

## MATLAB Code

Save the following code as `temp_humidity_sensing.m`:

```matlab
clc
clear all
close all

try
    % Create serial port object
    port = serialport("/dev/cu.usbserial-0001", 9600);  % Replace with your port name

    % Create figure and axes
    figure;
    
    % Temperature plot
    subplot(3, 1, 1);
    temperatureLine = animatedline;
    xlabel('Time');
    ylabel('Temperature (°C)');
    title('Real-Time Temperature Plot');
    grid on;
    
    % Humidity plot
    subplot(3, 1, 2);
    humidityLine = animatedline;
    xlabel('Time');
    ylabel('Humidity (%)');
    title('Real-Time Humidity Plot');
    grid on;
    
    % Heat index plot
    subplot(3, 1, 3);
    heatIndexLine = animatedline;
    xlabel('Time');
    ylabel('Heat Index (°C)');
    title('Real-Time Heat Index Plot');
    grid on;

    % Main loop for continuous data reading and plotting
    while true
        % Read data from serial port
        data = readline(port);
        data = char(data);
        data = strtrim(data);

        % Define regex patterns
        patternTemperature = 'Temperature: (\d+\.\d+)';
        patternHumidity = 'Humidity: (\d+\.\d+)';
        patternHeatIndex = 'Heat index: (\d+\.\d+)';

        % Extract values using regex
        temperatureMatch = regexp(data, patternTemperature, 'tokens', 'once');
        humidityMatch = regexp(data, patternHumidity, 'tokens', 'once');
        heatIndexMatch = regexp(data, patternHeatIndex, 'tokens', 'once');

        % Check if all matches are found
        if ~isempty(temperatureMatch) && ~isempty(humidityMatch) && ~isempty(heatIndexMatch)
            temperatureValue = str2double(temperatureMatch{1});
            humidityValue = str2double(humidityMatch{1});
            heatIndexValue = str2double(heatIndexMatch{1});

            % Check if values are valid numbers
            if ~isnan(temperatureValue) && ~isnan(humidityValue) && ~isnan(heatIndexValue)
                currentTime = now;
                
                % Add data points to the plots
                addpoints(temperatureLine, currentTime, temperatureValue);
                addpoints(humidityLine, currentTime, humidityValue);
                addpoints(heatIndexLine, currentTime, heatIndexValue);

                % Update plot limits
                xlim([currentTime - 10/86400, currentTime]);

                % Refresh the plots
                drawnow;

                % Display the sensor readings
                fprintf("Temperature: %.2f°C\n", temperatureValue);
                fprintf("Humidity: %.2f%%\n", humidityValue);
                fprintf("Heat Index: %.2f°C\n", heatIndexValue);
            else
                fprintf("Invalid temperature, humidity, or heat index value.\n");
            end
        else
            fprintf("Invalid data format: %s\n", data);
        end
    end

catch exception
    fprintf("Error: %s\n", exception.message);
    if exist('port', 'var') && isvalid(port)
        fclose(port);
        delete(port);
        clear port;
    end
end
```

## Usage

1. Connect the Arduino board to your computer via USB.
2. Open MATLAB and navigate to the directory containing `temp_humidity_sensing.m`.
3. Run the script by typing `temp_humidity_sensing` in the MATLAB command window.
4. A figure will appear showing real-time temperature, humidity, and heat index measurements.
5. The command window will display the current sensor readings.
6. To stop the program, use Ctrl+C in the MATLAB command window.

## Customization

- To change the serial port, modify the `serialport()` function call with the appropriate port name.
- Adjust the `xlim([currentTime - 10/86400, currentTime]);` line to change the time window of the plots.

## Troubleshooting

- Ensure the correct serial port is specified in the `serialport()` function.
- Check that the Arduino is properly connected and the correct sketch is uploaded.
- Verify that the baud rate in the MATLAB script matches the one set in the Arduino sketch (9600 in this case).
- Make sure the data format sent by the Arduino matches the expected format in the MATLAB script.

## Contributing

Contributions to enhance the project are welcome. Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
