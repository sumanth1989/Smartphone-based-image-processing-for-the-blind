clc
clear 
close all

%%Setup

imaqreset % Reset all vid objects
vid = VideoReader('IMG_6206.MOV'); %Setup object to read video files
f = figure;

%% Import data

while hasFrame(vid)
    video_frame = readFrame(vid); %Read frame from vid object
    video_frame = rot90(video_frame);   %Rotate frame 90 degrees for better viewing

%% Threshold frames in different color spaces for traffic light detection

    [~,video_Ycbr] = Ycbr_color_thresholding (video_frame);
    [~,video_Hsv] = HSV_color_thresholding (video_frame);
    [~,video_RGB] = RGB_color_thresholding (video_frame);
    [~,video_Lab] = Lab_color_thresholding (video_frame);

%% Display thresholded frames

    figure(1)
    subplot(3,3,1)
    imshow(video_frame) 
    title(' Original Image ')
    subplot(3,3,2)
    imshow(video_Ycbr) 
    title(' YCBR Thresholding ')
    subplot(3,3,3)
    imshow(video_Hsv) 
    title (' HSV Thresholding ')
    subplot(3,3,4)
    imshow(video_RGB) 
    title (' RGB Thresholding ')
    subplot(3,3,5)
    imshow(video_Lab) 
    title (' L*A*B Thresholding ')
  
%% Blob Detection & Labelling
    
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 10);
    bbox_Hsv = step(blobAnalysis, im2bw(video_Hsv));
    result_Hsv = insertShape(video_frame, 'Rectangle', bbox_Hsv, 'Color', 'green');
    bbox_Ycbr = step(blobAnalysis, im2bw(video_Ycbr));
    result_Ycbr = insertShape(video_frame, 'Rectangle', bbox_Ycbr, 'Color', 'green');
    
    
 %% Display Blobl Analysis frames  
    figure (2)
    subplot(2,1,1)
    imshow(result_Hsv) 
    title(' Blob Analysis on HSV Results ')
    subplot(2,1,2)
    imshow(result_Ycbr) 
    title(' Blob Analysis on YCBR Results ')
    
    pause(.05)

 %Code to stop execution of program 
    if(get(f,'currentkey') == 'a')
       break;
    end
end
