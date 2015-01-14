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
%   imageA(mandatory)- First binary image ground truth
%   imageB(mandatory)- Second binary image edge detection attempt
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
%%Figure of Merit Based Fitness Functions, Wenlong Fu
%in Genetic Programming for Edge Detection
% breaks because it does not take into account all pixels and will let a
% static image pass, in all cases
% DFP = diffMap .* imageB;%the distance of one predicted edge point i to the nearest true edge point
% DTP= diffMap.* imageA;% the nearest distance from a true edge point i to a predicted edge point
% DOverlap = diffMap.* (imageA.*imageB);
% DUnion = DFP + DTP - DOverlap;
% alpha = 1/9; % balances for type one errors
% beta = 1/9; % is a factor for the response on the false edge points
% Np = sum(sum(imageB));
% Nt = sum(sum(imageA));
% Nfm = sum(sum(imageB - (imageA.*imageB))); % number of false positives
% unionNpt = Np+Nt - Nfm;
% divisor = max([Np Nt]);
% 
% all of the exponents on these functions can be replaced by K and may need
% to be k rooted at the end like the BDM
% FOM = 1/divisor*sum(sum(1./(1+alpha.*DFP.^2)));
%  Fnn = (1/Nt*sum(sum(1./(1+alpha.*DTP))))*(1/(1+(beta*Nfm/Nt)));
% Fb = 1/(unionNpt)*sum(sum(1./(1+alpha*DUnion.^2)));
% if(Fnn < 5)
%    this = 5; 
% end
% val = Fnn;



%% my attempt
%
%increases the penalty for false negatives, a false negative occures when
%the difference in the distance between the closest edge point gets
%sufficiently large (in other words the edge point has been moved more than
%x distance away from where the edge is supposed to be. This penalty is
%included because the results to this point have been yeilding sparse
%images, thus the sparsity of images must be discouraged in the fitness


val = ((1/numPos)*((sum(sum(diffMap.^k)))+sum(sum((diffMap.*single(diffMap >10)).^k)))).^(1/k);
% old function original BDM or FOM
%val= ((1/numPos)*(sum(sum(diffMap.^k)))).^(1/k);

%---------------------------
%% FINAL PROCEDURES
%---------------------------















