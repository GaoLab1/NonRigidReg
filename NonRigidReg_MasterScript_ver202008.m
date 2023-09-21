% NonRigidReg_MasterScript
% Basic workflow for general projects in lab

% Pre-1st-script image processing
% (1) Prepare the pre and post image, run TurboReg on ImageJ (post to pre;
% "scaled rotation" mode) to rigidly register the images.
% (2) Output file is a 2-channel image.  Remove the 2nd channel.
% (3) Use "Merge channel" to overlap the pre and post images (order does 
% not matter)
% (4) Crop out a square ROI to be analyzed (i.e. an ROI that fully 
% composes of samples, i.e. leaving out the blank spaces that resulted 
% from image rotation, etc)
% (5) downsample by "Binning" (this step dramatically reduces computational
% time; we typically down-sample to < 2000 by 2000 pixels)
% (6) "Split channels" to break apart the pre and post images; save 
% seperately as TIF in a folder

%% Load Image
% Change the path in imread to your images, png/tiff are both fine
% When running registration, 10-20 points should be enough
% Predction can indicate success registration sometimes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Important%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Enter "imgPair.measResults" after run to make sure it's not empty%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgPair.moving.input = imread('post_expansion_image_here.tif'); % set to post
imgPair.static.input = imread(['pre_expansion_image_here.tif']); % set to pre; this is ground truth
imgSize = size(imgPair.moving.input,1);

%% Run 1st Script & Save Workspace
% Result *cannot* be recalled, make sure to save it if you want

imgPair = imageRegistrationWorkflowParfor(imgPair,imgSize,1);
currTime = clock;
timestamp = [num2str(currTime(1)*10000+ currTime(2) * 100 + currTime(3)) '-' ...
    num2str(currTime(4),'%.2d') '_' num2str(currTime(5),'%.2d')];
save(['Workspace_After_Workflow_' timestamp])

%% Set Parameters
imgPair.info.pixelWidth = 0.17;  % um
sampleInterval = 5; 
% this is the spacing between pixels where distortion is calculated; 
% larger values reduce the x-resolution of the output error plot, but
% significantly reduces computational time

%% Run 2nd Script & Save Workspace
% Results can be recalled
% imgPair.static.windowed = pre image
% imgPair.moving.windowed = post image (non-distorted)
% imgPair.moving.registered = post image (distorted)
% Enter the following in the command window
% imwrite(name of the variable,"name.tiff") to export image to tiff
% imwrite(imgPair.static.windowed,"name.tiff") to export pre image to tiff
% imwrite(imgPair.moving.windowed,"name.tiff") to export post image to tiff
%imgPair.measResults 

autoSave = 0;
read_saved_workspace = 0;

imgPair = measurementError(imgPair,sampleInterval,...
            autoSave,read_saved_workspace);
currTime = clock;
timestamp = [num2str(currTime(1)*10000+ currTime(2) * 100 + currTime(3)) '-' ...
    num2str(currTime(4),'%.2d') '_' num2str(currTime(5),'%.2d')];
save(['Workspace_After_ErrorAnalysis_' timestamp])





