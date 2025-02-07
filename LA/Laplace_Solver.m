% PA 4
set(0, 'DefaultFigureWindowStyle', 'docked');

nx = 100;
ny = 100;
n1 = 10000;
V = zeros(nx, ny);

%SidesToZero = 1;

for k = 1:n1  %iterative
    for i = 1:nx % loop matrix
        for j = 1:ny
            % V(1) = 1;
            % V(nx) = 0;
            if (i == 1)
                V(i, j) = 1; % Set left to 1

            elseif (i == nx) 
                V(i,j) = 0; % Set right to 0

            elseif (j == 1)
                V(i,j) = V(i, j+1); % Insulating
                %V(i,j) = 0; % Set top to 0

            elseif (j == ny)
               V(i,j) = V(i, j-1); % insulating
               %V(i,j) = 0; % set bottom to 0
           
            else
                V(i,j) = (V(i+1, j) + V(i-1, j) + V(i, j+1) + V(i, j-1)) / 4; % Laplace finte difference
            end
        end
    end

    if mod(k, 50) == 0 % k multiple of 50
        surf(V');
        shading interp
        %v_prime = imboxfilt(V,3);
        %imshowpair(V,v_prime)
        pause(0.05);
    end
end

[Ex, Ey] = gradient(V);

figure
quiver(-Ey', -Ex', 1);

