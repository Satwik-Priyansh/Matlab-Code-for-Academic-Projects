clc
clear all
close all
try
    % Create serial port object
    port = serialport("/dev/cu.usbserial-0001", 9600);  % Replace "/dev/cu.usbserial-0001" with the appropriate port name and baud rate

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

        % Convert data to character vector or string scalar
        data = char(data);  % or data = string(data);

        % Remove leading/trailing whitespaces and newline characters
        data = strtrim(data);

        % Define regex patterns
        patternTemperature = 'Temperature: (\d+\.\d+)';
        patternHumidity = 'Humidity: (\d+\.\d+)';
        patternHeatIndex = 'Heat index: (\d+\.\d+)';

        % Extract temperature, humidity, and heat index values using regex
        temperatureMatch = regexp(data, patternTemperature, 'tokens', 'once');
        humidityMatch = regexp(data, patternHumidity, 'tokens', 'once');
        heatIndexMatch = regexp(data, patternHeatIndex, 'tokens', 'once');

        % Check if temperature, humidity, and heat index matches are found
        if ~isempty(temperatureMatch) && ~isempty(humidityMatch) && ~isempty(heatIndexMatch)
            % Extract values from the regex matches
            temperatureValue = str2double(temperatureMatch{1});
            humidityValue = str2double(humidityMatch{1});
            heatIndexValue = str2double(heatIndexMatch{1});

            % Check if temperature, humidity, and heat index values are valid numbers
            if ~isnan(temperatureValue) && ~isnan(humidityValue) && ~isnan(heatIndexValue)
                % Get current time
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

    % Clean up
    clear port;
catch exception
    fprintf("Error: %s\n", exception.message);
    if exist('port', 'var') && isvalid(port)
        fclose(port);
        delete(port);
        clear port;
    end
end
