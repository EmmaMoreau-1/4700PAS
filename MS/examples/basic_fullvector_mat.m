% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = 1.0;           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

neffs = zeros(10,1);
n2s = zeros(10,1);

% First consider the fundamental TE mode:
for n=1:10
    n2 = (n-1)*0.015 + 3.305;
    disp(n2);
    [x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([n1,n2,n3],[h1,h2,h3], ...
                                            rh,rw,side,dx,dy); 

    [Hxe,Hye,neffe] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000A');
    neffs(n) = neffe;
    n2s(n) = n2;
    %[Hxm,Hym,neffm] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000S');

    %[Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000A');
    
    %fprintf(1,'neff = %.6f\n',neff);
    
    figure(n);
    subplot(121);
    contourmode(x, y, Hxe);
    view(0,90);
    title('Hx (TE mode) for n2 = ' + string(n2)); xlabel('x'); ylabel('y'); 
    for v = edges, line(v{:}); end
    
    subplot(122);
    contourmode(x,y,Hye);
    view(0,90);
    title('Hy (TE mode) for n2 = ' + string(n2)); xlabel('x'); ylabel('y'); 
    for v = edges, line(v{:}); end
    
    % Next consider the fundamental TM mode
    % (same calculation, but with opposite symmetry)
    
    %[Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000S');
    
    %fprintf(1,'neff = %.6f\n',neff);
    
    % figure(n+nmodes);
    % subplot(121);
    % contourmode(x,y,Hxm(:, :, n));
    % view(0,90);
    % title('Hx (TM mode) for n = ' + string(n)); xlabel('x'); ylabel('y'); 
    % for v = edges, line(v{:}); end
    % 
    % subplot(122);
    % contourmode(x,y,Hym(:, :, n));
    % view(0,90);
    % title('Hy (TM mode) for n = ' + string(n)); xlabel('x'); ylabel('y'); 
    % for v = edges, line(v{:}); end
end
figure 
plot(n2s, neffs);
title("Neff vs changing ridge index");
xlabel("Ridge Index");
ylabel("Neff");

%1. First obtaining the first TE and first TM mode, hy dominant
%2. Change to nmodes = 10 and add a for loop to create the 20 plots (10 TM
% and 10 TE)
%3. Changed to surf() in contourmode(). Easier to see the intensity 
%4. As ridge gets narrow, the field doesn't wanna go in the waveguide.
% Increasing the dx, dy makes the grid less precise and more pixellated
%5. As ridge index decreases, the field doesn't wanna go in the waveguide.