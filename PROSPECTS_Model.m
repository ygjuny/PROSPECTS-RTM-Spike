% _______________________________________________________________________
% PROSPECTS model
% Version 1.0 (May, 20th 2025)
% _______________________________________________________________________
% for any question or request, please contact:
%
% Dr. Guijun Yang & Mr. Hongrui Wen
% State Key Laboratory of Loess Science, College of Geological Engineering and Geomatics, Chang’an University, Xi’an, 710064, China
% Key Laboratory of Quantitative Remote Sensing in Agriculture of Ministry of Agriculture and Rural Affairs, Information Technology Research Center, Beijing Academy of Agriculture and Forestry Sciences, Beijing 100097, China
% E-mail: guijun.yang@163.com & hhwenhongrui@126.com
%
% https://github.com/ygjuny/PROSPECTS-RTM-Spike
% _______________________________________________________________________
% Function: Simulate spike spectra properties from 400 nm to 2500 nm with 1 nm interval
%    Input:
%           - AGDD = accumulated growing degree days in °C
%           - Cab = chlorophyll a+b content in ug/cm?
%           - Car = carotenoids content in ug/cm?
%           - Cw  = equivalent water thickness in g/cm? or cm
%           - Cm  = dry matter content in g/cm?
%   Output:spike reflectance
%
% Acknowledgement: The authors thank the PROPSECT team for providing the
%                  calctav.m.

function LRT=PROSPECTS_Model(AGDD,Cab,Car,Cw,Cm)

data = dataSpec_PROSPECTS;
lambda  = data(:,1);
Kab     = data(:,2);    Kcar    = data(:,3);
Kw      = data(:,4);    Km      = data(:,5);
nr0      = data(:,6);    k      = data(:,7);
b      = data(:,8);
% _______________________________________________________________________
%The following parameter values were derived specifically from the experimental
%cultivars used in this study and have not yet been validated for other wheat varieties.
W = 18.949 / (1 + 1.841 .* exp((-0.005) .* (AGDD-1451.377))) - 54.637 .* Cm;
nr      = nr0 .* (1 - exp(-W .* k + b));
N = W .* W .* (-0.0153) + W .* 0.2214 + 1.6458;
% _______________________________________________________________________
Kall    = (Cab*Kab+Car*Kcar+Cw*Kw+Cm*Km)/N;
j       = find(Kall>0);               % Non-conservative scattering (normal case)
t1      = (1-Kall).*exp(-Kall);
t2      = Kall.^2.*expint(Kall);
tau     = ones(size(t1));
tau(j)  = t1(j)+t2(j);

% ***********************************************************************
% reflectance and transmittance of one layer
% ***********************************************************************
% Allen W.A., Gausman H.W., Richardson A.J., Thomas J.R. (1969),
% Interaction of isotropic ligth with a compact plant leaf, J. Opt.
% Soc. Am., 59(10):1376-1379.
% ***********************************************************************
% reflectivity and transmissivity at the interface
%-------------------------------------------------
talf    = calctav(40,nr);
ralf    = 1-talf;
t12     = calctav(90,nr);
r12     = 1-t12;
t21     = t12./(nr.^2);
r21     = 1-t21;

% top surface side
denom   = 1-r21.*r21.*tau.^2;
Ta      = talf.*tau.*t21./denom;
Ra      = ralf+r21.*tau.*Ta;

% bottom surface side
t       = t12.*tau.*t21./denom;
r       = r12+r21.*tau.*t;

% ***********************************************************************
% reflectance and transmittance of N layers
% Stokes equations to compute properties of next N-1 layers (N real)
% Normal case
% ***********************************************************************
% Stokes G.G. (1862), On the intensity of the light reflected from
% or transmitted through a pile of plates, Proc. Roy. Soc. Lond.,
% 11:545-556.
% ***********************************************************************
D       = sqrt((1+r+t).*(1+r-t).*(1-r+t).*(1-r-t));
rq      = r.^2;
tq      = t.^2;
a       = (1+rq-tq+D)./(2*r);
b       = (1-rq+tq+D)./(2*t);

bNm1    = b.^(N-1);                  %
bN2     = bNm1.^2;
a2      = a.^2;
denom   = a2.*bN2-1;
Rsub    = a.*(bN2-1)./denom;
Tsub    = bNm1.*(a2-1)./denom;

% Case of zero absorption
j       = find(r+t >= 1);
Tsub(j) = t(j)./(t(j)+(1-t(j))*(N-1));
Rsub(j)	= 1-Tsub(j);

% Reflectance and transmittance of the leaf: combine top layer with next N-1 layers
denom   = 1-Rsub.*r;
tran    = Ta.*Tsub./denom;
refl    = Ra+Ta.*Rsub.*t./denom;

LRT     = [lambda refl tran];
