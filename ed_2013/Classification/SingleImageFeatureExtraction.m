depthPyramids = 9;
direction = 'reduce';
im = imread('sun_aacyknxirsfolpon.jpg');
% FeatureSet
% ValidationData
% TestingData
CenterSurroundFineMin = 3;
CenterSurroundFineMax = 5;
CenterSurroundCourseDistance = [3,4];%must be a scalar
InterpolationFilter = [1,1]/2; %this can be adjusted for better results in the future
Orientation = [3*pi/4,pi/2,pi/4,0];
gb = cell(length(Orientation),1);
Scales = 4;
lambda  = 8;
psi     = [0 pi/2];
gamma   = 0.5;
bw      = 1;
for i = 1: length(Orientation)
    gb{i} = gabor_fn(bw,gamma,psi(1),lambda,Orientation(i))+ 1i * gabor_fn(bw,gamma,psi(2),lambda,Orientation(i));
end

[ Pyramids,RedChannel,GreenChannel,BlueChannel,YellowChannel,IntensityChannel ] = ChannelCreation(im, depthPyramids,direction );
[ RG,BY,I ] = CenterSurround( RedChannel,GreenChannel,BlueChannel,YellowChannel,IntensityChannel, CenterSurroundFineMax, CenterSurroundFineMin, CenterSurroundCourseDistance );
MOChannel = OrientationChannel( Pyramids, Orientation,Scales,gb );
NumSquaresPerSide = 4;
[ gist1 ] = SumSubRegions(RG, NumSquaresPerSide );
[ gist2 ] = SumSubRegions(BY, NumSquaresPerSide );
[ gist3 ] = SumSubRegions(I, NumSquaresPerSide );
[ gist4 ] = SumSubRegions(MOChannel, NumSquaresPerSide );
gist4 = real(gist4); % should i keep the imaginary part? not likely
gistfinal  = [gist1;gist2;gist3;gist4];
