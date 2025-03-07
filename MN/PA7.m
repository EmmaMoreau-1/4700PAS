%PA7

% sweep V1 from -10V to 10V, plot Vo and V3 vs input
% sweep w from 0 to 100

% Constants
G1 = 1;
G2 = 1/2;
G3 = 1/10;
G4 = 1/0.1;
Go = 1/1000;
a = 100;
C1 = 0.25;
L = 0.2;

% G matrix
G = [G1 1  -G1   0 0    0  0   0
    -G1 0  G2+G1 1 0    0  0   0
     0  0  0    -1 G3   0  0   0
     0  0  0     0 0    1  G4 -G4
     0  0  0     0 0    0 -G4  G4+Go
     0  0  0     0 a*G3 0 -1   0
     0  0 -1     0 1    0  0   0
     1  0  0     0 0    0   0  0];

% C + L matrix
C = [C1 0 -C1 0 0 0 0 0
    -C1 0  C1 0 0 0 0 0
     0 0   0  0 0 0 0 0
     0 0   0  0 0 0 0 0
     0 0   0  0 0 0 0 0
     0 0   0  0 0 0 0 0
     0 0   0  L 0 0 0 0
     0 0   0  0 0 0 0 0];

Vs = -10;

% F matrix
F = [0 0 0 0 0 0 0 Vs].';
Vos = zeros(200, 1);
Vss = zeros(200, 1);
V3s = zeros(200, 1);

w = 0;

for i=1:200
    Vs = Vs + i*(0.001) - 0.001;
    disp(Vs);
    Vss(i) = Vs;
    % V = linsolve(G + 1i*w*C, F');
    F = [0 0 0 0 0 0 0 Vs].';
    V = G\F;
    Vo = V(8);
    Vos(i) = Vo;
    V3 = V(5);
    V3s(i) = V3;
end

figure
plot(Vss, Vos);
hold on
plot(Vss, V3s);
title("DC analysis");
xlabel("Vin");
ylabel("V");
legend("Vo", "V3");
hold off

Vs = 10;

% F matrix
F = [0 0 0 0 0 0 0 Vs].';

ws = zeros(20000, 1);
Vos = zeros(20000, 1);


for i = 1:20000
    w = i/2;
    ws(i) = w;
    V = (G + 1i*w*C)\F;
    Vo = V(8);
    Vos(i) = Vo;
    V3 = V(5);
    V3s(i) = V3;
end

figure 
semilogx(ws, 20*log(Vos/10));
title("AC analysis dB");
xlabel("w");
ylabel("V");

ws = zeros(200, 1);
Vos = zeros(200, 1);
Vss = zeros(200, 1);
V3s = zeros(200, 1);

for i = 1:200
    w = i/2;
    ws(i) = w;
    V = (G + 1i*w*C)\F;
    Vo = V(8);
    Vos(i) = Vo;
    V3 = V(5);
    V3s(i) = V3;
end

figure
plot(ws, Vos);
hold on
plot(ws, V3s);
title("AC analysis");
xlabel("w");
ylabel("V");
legend("Vo", "V3");
hold off


w = 3.14;
Vos = zeros(20000, 1);
Cs = zeros(20000, 1);

for i=1:20000
     Cr = normrnd(C1, 0.05);
     Cs(i) = Cr;
     C = [Cr 0 -Cr 0 0 0 0 0
        -Cr 0  Cr 0 0 0 0 0
         0 0   0  0 0 0 0 0
         0 0   0  0 0 0 0 0
         0 0   0  0 0 0 0 0
         0 0   0  0 0 0 0 0
         0 0   0  L 0 0 0 0
         0 0   0  0 0 0 0 0];

     V = (G + 1i*w*C)\F;
     Vo = V(8);
     Vos(i) = Vo;
end

figure 
histogram(abs(Vos/10), 10);
title("Histo Vo/Vi");
xlabel("Vo/Vi");
ylabel("Number");

figure 
histogram(Cs, 10);
title("Histo C Values");
xlabel("C");
ylabel("Number");