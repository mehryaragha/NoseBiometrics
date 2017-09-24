% Modified by: Mehryar Emambakhsh
% Email: mehryar_emam@yahoo.com
% Date: 25 June 2017
% Paper:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

% This is a modified code from the paper:
% B. S. Manjunath and W.Y. Ma, "Texture features for browsing and retrieval of image data"
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI - Special issue on Digital Libraries), 
% vol. 18, no. 8, pp. 837-42, Aug. 1996.
%, which works on meshgrid input image.
% For more info, please check:
% http://old.vision.ece.ucsb.edu/texture/software/
% access time: 21:10 on 25 June 2017

% Or check the spplementary material of the PAMI paper below:
% M. Emambakhsh and A. Evans, “Nasal patches and curves for an expression-robust 3D face recognition,” 
% IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI), vol. 39, no. 5, pp. 995-1007, 2017. 

function [Gr,Gi] = gabor_by_meshgrid(N,index,freq,partition,flag)

% get parameters

s = index(1);
n = index(2);

Ul = freq(1);
Uh = freq(2);

stage = partition(1);
orientation = partition(2);

% computer ratio a for generating wavelets

base = Uh/Ul;
C = zeros(1,stage);
C(1) = 1;
C(stage) = -base;

P = abs(roots(C));
a = P(1);

% computer best variance of gaussian envelope

u0 = Uh/(a^(stage-s));
Uvar = ((a-1)*u0)/((a+1)*sqrt(2*log(2)));

z = -2*log(2)*Uvar^2/u0;
Vvar = tan(pi/(2*orientation))*(u0+z)/sqrt(2*log(2)-z*z/(Uvar^2));

% generate the spetial domain of gabor wavelets

j = sqrt(-1);

if (rem(N,2) == 0)
    side = N/2-0.5;
else
    side = fix(N/2);
end;

% x = -side:1:side;
% l = length(x);
% y = x';
% X = ones(l,1)*x;
% Y = y*ones(1,l);

[X, Y] = meshgrid(1: N(2), N(1): -1: 1);
X = X - mean(X(:)); Y = Y - mean(Y(:));

t1 = cos(pi/orientation*(n-1));
t2 = sin(pi/orientation*(n-1));

XX = X*t1+Y*t2;
YY = -X*t2+Y*t1;

Xvar = 1/(2*pi*Uvar);
Yvar = 1/(2*pi*Vvar);

coef = 1/(2*pi*Xvar*Yvar);

Gr = a^(stage-s)*coef*exp(-0.5*((XX.*XX)./(Xvar^2)+(YY.*YY)./(Yvar^2))).*cos(2*pi*u0*XX);
Gi = a^(stage-s)*coef*exp(-0.5*((XX.*XX)./(Xvar^2)+(YY.*YY)./(Yvar^2))).*sin(2*pi*u0*XX);

% remove the real part mean if flag is 1

if (flag == 1)
   m = sum(sum(Gr))/sum(sum(abs(Gr)));
   Gr = Gr-m*abs(Gr);
end;
