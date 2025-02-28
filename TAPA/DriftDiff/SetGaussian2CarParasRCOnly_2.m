Coupled = 1;
% setting to 0 changes V, E, rho to 0
TwoCarriers = 1; % setting to 0 removes P
RC = 1;

nx = 201;
l = 1e-6;

x =linspace(0,l,nx);
dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx;

% doping profile
% Linear
 Nd = (1e16 + x.*19e16*1e6) * 1e6; % Const. 1/cm3 (100 cm/m)^3
% Exponential
%Nd = (1e16 + exp(x.*3e6)*1e16) * 1e6; % Const. 1/cm3 (100 cm/m)^3
%Nd = 1e16 * 1e6;
% Make it go 1E16 to 20E16
% then change to exponential

NetDoping = ones(1,nx).*Nd; % doping
for i=1:length(NetDoping)
%    disp(x(i));
    disp(NetDoping(i));
end
x0 = l/2;
nw = l/20;
npDisturbance = 1e16*1e6*exp(-((x-x0)/nw).^2);
%npDisturbance = 0;
LVbc = 0;
RVbc = 0;

TStop = 14200000*1e-18;
PlDelt = 100000*1e-18;

PlotYAxis = {[-0.05 0.05] [-2e5 2e6] [-1.5e3 1.5e3]...
    [0 2e23] [0 1e22] [0 30e43]...
    [-20e32 15e32] [-2.5e33 2e33] [0e3 3e9] ...
    [-10e6 10e6] [-10e-3 10e-3] [0 30e22]};

doPlotImage = 0;
PlotFile = 'Gau2CarRC.gif';
