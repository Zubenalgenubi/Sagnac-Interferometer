% Step 1: Load the video
v = VideoReader('/Users/abhijit/Downloads/video2.mp4');

% Step 2: Define ROI
frame1 = readFrame(v); % Read the first frame
figure, imshow(frame1), title('Select ROI for Fringes');
roi = round(getrect); % Manually select ROI as [x y width height]
close;

% Step 3: Initialize variables
frameCount = 0;
positions = []; % To store peak positions

% Step 4: Process each frame
while hasFrame(v)
    frame = readFrame(v); % Read a frame
    frameROI = imcrop(frame, roi); % Crop the frame to the ROI

    % Convert to grayscale if necessary
    if size(frameROI, 3) == 3
        frameROI = rgb2gray(frameROI);
    end

    % Step 5: Find the brightest pixel in ROI
    [~, idx] = max(frameROI(:)); % Find maximum intensity
    [y, x] = ind2sub(size(frameROI), idx); % Get (x, y) coordinates

    % Save the position
    positions = [positions; x, y];
    frameCount = frameCount + 1;

    % Optional: Display progress
    if mod(frameCount, 10) == 0
        fprintf('Processed %d frames...\n', frameCount);
    end
end

% Step 6: Analyze and plot the shifts
xPositions = positions(:, 1); % X-coordinates of peak intensity
yPositions = positions(:, 2); % Y-coordinates of peak intensity

% Calculate pixel shifts
xShift = xPositions - xPositions(1); % Shift relative to the first frame
yShift = yPositions - yPositions(1);

% Plot the shifts
figure;
plot(1:frameCount, xShift, '-o', 'DisplayName', 'X Shift');
hold on;
plot(1:frameCount, yShift, '-o', 'DisplayName', 'Y Shift');
xlabel('Frame Number');
ylabel('Pixel Shift (pixels)');
legend;
title('Pixel Intensity Peak Shift Over Frames');
grid on;
%% 
% Apply moving average to smooth the data
windowSize = 20; % Adjust based on noise level
xShiftSmooth = movmean(xShift, windowSize);
yShiftSmooth = movmean(yShift, windowSize);

% Plot smoothed data
figure;
plot(1:frameCount, xShiftSmooth, '-b', 'DisplayName', 'X Shift (Smoothed)');
hold on;
plot(1:frameCount, yShiftSmooth, '-r', 'DisplayName', 'Y Shift (Smoothed)');
xlabel('Frame Number');
ylabel('Pixel Shift (pixels)');
legend;
title('Smoothed Pixel Intensity Peak Shift');
grid on;




  


