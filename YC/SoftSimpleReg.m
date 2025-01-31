winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15
% increasing frequency seems to allow for less scattering, the grating
% stops the propogation for the most part
f = 230e12;
lambda = c_c/f;

xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0;

% Removing the inclusion, propogates straight forward
% (width, height)
epi{1}(140:150,55:60)= c_eps_0*11.3;
epi{1}(40:50,55:60)= c_eps_0*11.3;
epi{1}(125:145,60:65)= c_eps_0*11.3;
epi{1}(45:65,60:65)= c_eps_0*11.3;
epi{1}(110:140,65:70)= c_eps_0*11.3;
epi{1}(50:80,65:70)= c_eps_0*11.3;
epi{1}(40:150,70:73)= c_eps_0*11.3;
epi{1}(20:170,73:76)= c_eps_0*11.3;
epi{1}(40:150,76:79)= c_eps_0*11.3;
epi{1}(60:130,79:83)= c_eps_0*11.3;
epi{1}(75:115,83:87)= c_eps_0*11.3;
epi{1}(80:110,87:91)= c_eps_0*11.3;
epi{1}(90:100,91:95)= c_eps_0*11.3;

% epi{1}(80:90,55:95)= c_eps_0*11.3;
% epi{1}(60:70,55:95)= c_eps_0*11.3;

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
% increase to remove the trapped fields
Plot.MaxEz = 10;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

% Boundary conditions
bc{1}.NumS = 1;
bc{1}.s(1).xpos = nx{1}/(4) + 1;
% Appears to change the starting x position
bc{1}.s(1).type = 'ss';

%bc{1}.s(1) has the function PlaneWaveBC
bc{1}.s(1).fct = @PlaneWaveBC;

% mag = -1/c_eta_0;
% Increasing mag appears to increase intensity
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
% Appears to increase propogation
%st = 15e-15;
st = -0.05;
% Also increase propogation
s = 0;
% change y position
y0 = yMax/2;
% Increase y amplitude
sty = 1.5*lambda;
% Set up all the parameters for the plane wave
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a';
% Changing to e adds reflection
% e is perfect electrical conductor
% a is perfect Magnetic 
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg

% simulates the Ez, Hx, Hy for the fields
% Plots permittivity and perbeability
% E-Mode
% No reflection off source
% progogates forward, hits inclusion, then starts scattering at lower
% wavelength







