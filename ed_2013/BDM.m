function [val,diffMap] = BDM(imageA,imageB,wFunc,k,dist)

%
%   LEGAL WARNING: This code is distrubuted under the CC-BY-ND
%        license. Check it out at:
%
%       http://creativecommons.org/licenses/by-nd/3.0/
%       http://creativecommons.org/licenses/by-nd/3.0/legalcode
%
%
% Function BDM
%  function [val,diffMap] = BDM(imageA,imageB,func,k,dist)
%
% This method calculates the dissimilarity between two binary images using
%   Baddeley's Delta Metric [1,2]. For usages, see [3,4].
%
% [Inputs]
%   imageA(mandatory)- First binary image
%   imageB(mandatory)- Second binary image
%   wFunc(optional)- Function w used in the blending of the distances.
%       It can be
%           'x'     ->  w(x)=x
%           'lnx'   ->  w(x)=ln(x)
%           'log10x'->  w(x)=log_10(x)
%           'minXK' ->  w(x)=min(x,K)
%   k(optional)- k power to be used. It must be a positive scalar.
%   dist(optional)- The pointwise distance used. It can be 'euc' (Euclidean), 
%       'che' (Chebyshev) or 'manh' (Manhattan)
%
% [outputs]
%   val- Dissimilarity
%   diffMap- Map containing th point-by-point discrepancies
%
% [usages]
%
%   value= BDM(imageA,imageB)
%       [equiv. to   value= BDM(imageA,imageB,'x')]
%       [equiv. to   value= BDM(imageA,imageB,'x',2)]
%       [equiv. to   value= BDM(imageA,imageB,'x',2,'euc')]
%
%
% [author]
%   Carlos López Molina (carlos.lopez@unavarra.es)
%
% [references]
%   [1] A. J. Baddeley; An error metric for binary images 
%       Robust Computer Vision: Quality of Vision Algorithms, 
%       Wichmann Verlag, Karlsruhe, 1992, pp. 59–78.
%
%   [2] A. J. Baddeley; 
%       Errors in binary images and an Lp version of the Hausdorff metric. 
%       Nieuw Archief voor Wiskunde, 10:157–183, 1992.
%
%   [3] Lopez-Molina,C., Bustince,H., Fernandez,J., Couto,P., De Baets,B.
%       A gravitational approach to edge detection based on triangular norms. 
%       Pattern Recognition 43(11), 3730-3741 (2010)
%
%   [4] Generating fuzzy edge images from gradient magnitudes, 
%       C. Lopez-Molina, B. De Baets and H. Bustince, 
%       Computer Vision and Image Understanding, In press
%
% [versions]
%
%   2.00 /2011-08-18/ Faster version launched
%



%---------------------------
%% INTERNAL PARAMETERS
%---------------------------


%---------------------------
%% ARGUMENTS
%---------------------------
if (nargin<2 || nargin>5)
    error('Wrong number of parameters in function BDM: %d is an incorrect number',nargin);
end

%---------------------------
%% PREPROCESSING
%---------------------------

if (nargin<5)
    dist='euc';
end

if (nargin<4)
    k=2;
end

if (nargin<3)
    wFunc='x';
end

numPos=size(imageA,1)*size(imageB,2);


%---------------------------
%% PROCESSING
%---------------------------

%Computing d

if (strcmp(dist,'euc'))
    mapA=bwdist(imageA);
    mapB=bwdist(imageB);
elseif(strcmp(dist,'che'))
    mapA=bwdist(imageA,'chessboard');
    mapB=bwdist(imageB,'chessboard');
elseif(strcmp(dist,'manh'))
    mapA=bwdist(imageA,'cityblock');
    mapB=bwdist(imageB,'cityblock');
else
    error('Wrong parameters in function BDM: %s is not a valid distance name',dist);
end

%Computing w

if(strcmp(wFunc,'lnx'))
    mapA=log(mapA);
    mapB=log(mapB);

elseif (strcmp(wFunc,'x'))
    mapA=mapA;
    mapB=mapB;
    
elseif(strcmp(wFunc,'log10x'))
    mapA=log10(mapA);
    mapB=log10(mapB);
    
elseif(strfind(wFunc,'minX'))
    %Shound be 'minXnuM', e.g. minX5 or minX3.2
    auxWFunc=regexprep(wFunc,'minX','');
    T=str2double(auxWFunc);
    mapA=min(mapA,T);
    mapB=min(mapB,T);
else
    error('Wrong parameters in function BDM: %s is not a valid w function name',wFunc);
end

diffMap=abs(mapA-mapB);


val= ((1/numPos)*(sum(sum(diffMap.^k)))).^(1/k);

%---------------------------
%% FINAL PROCEDURES
%---------------------------















