%my PCA
%X is data, each row is a sample
%per is percentage of eigenvalues included in the transformation
%W is PCA transformation matrix

% Z = W'*(x - m)
% m is mean of x
% W has the eigenvectors of S (estimate of Sigma)
% cov(z) = W'SW
% Sigma is Cov(x)

function [Z, W, E, mVal,mVar] = myPCA(X, per)
% clear all
% per = .9;
% x1 = 0:0.01:10;
% x2 = 0:0.02:20;
% x3 = 0:0.05:50;
% 
% x = [ sin(x1') cos(x2') sin(x3.^2')];
% 
% X = rand(size(x)) + x;

mVal = mean(X,1);
meanMat = ones(size(X))*diag(mVal);
mVar = var(X);
Xm = (X -  meanMat);

sigma = cov(Xm);

[U,E,V] = svd (sigma);

tra = trace(E);
sm = 0;
for k=1:length(E)
    sm = sm + E(k,k);
    if (sm/tra > per)
        break
    end
end

%k = round(length(E)*per);

W = V(:,1:k);

Z = (X - meanMat)*W;
