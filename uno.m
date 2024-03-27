clc;
clear all;
close all;
s = serialport("/dev/cu.usbserial-10", 9600, "Timeout", 10);

% Set up figure for real-time plotting
figure;
h = animatedline('Color', 'b', 'Marker', 'o');
xlabel('Time (s)');
ylabel('Distance (cm)');
title('Real-Time Distance Plot');
grid on;

time = datetime('now');

try
    while ishandle(h.Parent)  % Continue plotting until the figure is closed
        % Read a line of data from the serial port
        line = readline(s);

        % Extract the numeric part of the line
        numericPart = regexprep(line, '[^0-9.]', '');

        % Convert the numeric part to a double
        distance = str2double(numericPart);

        % Print the distance in the command window
        disp(['Distance: ' num2str(distance) ' cm']);

        % Check if the distance is less than 10 cm
        if distance < 30
            % Generate a louder high-frequency sine wave
            fs = 8192;  % Sampling frequency
            duration = 1.0;  % Increased duration of the sound
            frequency = 4000;  % Frequency of the sine wave
            amplitude = 4.0;  % Increased amplitude for a louder sound

            t = 0:1/fs:duration;
            signal = amplitude * sin(2*pi*frequency*t);

            % Play the high-frequency sound
            sound(signal, fs);
        end

        % Add the data point to the animated line
        addpoints(h, datenum(datetime('now') - time), distance);

        % Update the plot
        drawnow;

        % Pause for a short duration to control the loop rate
        pause(0.1);
    end
catch e
    disp("Error reading or plotting data.");
    disp(e);
end

% Close the serial port
fclose(s);
clear s;
