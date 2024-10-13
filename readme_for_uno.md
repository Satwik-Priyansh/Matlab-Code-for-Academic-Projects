# Ultrasonic Sensing with MATLAB

This project demonstrates real-time ultrasonic distance sensing using an Arduino board and MATLAB. It provides continuous distance measurements, real-time plotting, and an audible alert for close objects.

## Features

- Real-time distance measurement and plotting
- Range detection up to 400 cm (depending on the sensor used)
- Audible alert for objects closer than 30 cm
- Continuous data logging and visualization

## Requirements

- Arduino board with ultrasonic sensor (e.g., HC-SR04)
- MATLAB R2019b or later
- Arduino IDE (for uploading code to the Arduino)
- USB cable for connecting Arduino to computer

## Setup Instructions

1. **Arduino Setup**
   - Connect your ultrasonic sensor to the Arduino board.
   - Upload the appropriate sketch to your Arduino (code not provided in this README).

2. **MATLAB Setup**
   - Ensure you have MATLAB R2019b or later installed.
   - Copy the provided MATLAB script into a new file named `ultrasonic_sensing.m`.

## MATLAB Code

Save the following code as `ultrasonic_sensing.m`:

```matlab
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
        
        % Check if the distance is less than 30 cm
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
```

## Usage

1. Connect the Arduino board to your computer via USB.
2. Open MATLAB and navigate to the directory containing `ultrasonic_sensing.m`.
3. Run the script by typing `ultrasonic_sensing` in the MATLAB command window.
4. A figure will appear showing real-time distance measurements.
5. The command window will display the current distance readings.
6. An audible alert will sound when an object is detected closer than 30 cm.
7. To stop the program, close the figure window.

## Customization

- To change the serial port, modify the `serialport()` function call with the appropriate port name.
- Adjust the `distance < 30` condition to change the proximity alert threshold.
- Modify the sound parameters (frequency, amplitude, duration) to change the alert tone.

## Troubleshooting

- Ensure the correct serial port is specified in the `serialport()` function.
- Check that the Arduino is properly connected and the correct sketch is uploaded.
- Verify that the baud rate in the MATLAB script matches the one set in the Arduino sketch (9600 in this case).

## Contributing

Contributions to enhance the project are welcome. Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
