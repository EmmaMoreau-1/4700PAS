% Without inclusion

set(0, 'DefaultFigureWindowStyle', 'docked')
set(0, 'defaultaxesfontsize', 20)
set(0, 'defaultaxesfontname', 'Times New Roman')
set(0, 'DefaultLineLineWidth', 2);

nx = 50;
ny = 50;
V = zeros(nx, ny);
G = sparse(nx*ny, nx*ny);

for i = 1:nx
    for j = 1:ny
        % mapping function
        n = j + (i-1)*ny;

        % BCs
        % i = 1
        if i == 1
            G(n,:) = 0;
            G(n,n) = 1; % Diagonal
        % i = nx
        elseif i == nx
            G(n, :) = 0;
            G(n,n) = 1;
        % j = 1
        elseif j == 1
            G(:, n) = 0;
            G(n,n) = 1; % Diagonal
        % j = ny
        elseif j == ny
            G(:, n) = 0;
            G(n,n) = 1; % Diagonal
        else 
            % Mapping all the nodes
            nxm = j + (i-2)*ny; % (i-1, j)
            nxp = j + i*ny; % (i+1, j)
            nym = j-1 + (i-1)*ny; % (i, j-1)
            nyp = j+1 + (i-1)*ny; % (i, j+1)
            

            % All from finite difference equation, placing the coefficents in the equation vector
            G(n,n) = -4;
            G(nxm, n) = 1;
            G(nxp, n) = 1;
            G(n, nym) = 1;
            G(n, nyp) = 1;

        end
    end
end

figure('name', 'Matrix')
spy(G)

nmodes =9;
[E,D] = eigs(G, nmodes, 'SM');

figure('name', 'EigenValues')
plot(diag(D), '*');

np = ceil(sqrt(nmodes))
figure('name', 'Modes')
for k = 1:nmodes
    M = E(:,k);
    for i = 1:nx
        for j = 1:ny
            n = i + (j-1)*nx; % Remapped
            V(i,j) = M(n);
        end
        subplot(np,np,k), surf(V, 'linestyle', 'none')
        title(['EV = ' num2str(D(k,k))])
    end
end