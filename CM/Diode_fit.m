% PA 8

% Set seed
rng(10110)

% Sample
Is = 0.01 * 10^-12; % A
Ib = 0.1 * 10^-12; % A
Vb = 1.3; 
Gp = 0.1;

% V vector, -1.95V to 0.7V 200 steps
V = linspace(-1.95, 0.7, 200);

% I vector
I = zeros(200, 1);

% Second I vector
I_var = zeros(200, 1);

% Random variation
r = randi([-1 1],200,1);

for i=1:length(V)
    V_i = V(i);
    % Calculate I
    I_i = Is*(exp(1.2/0.025*V_i) -1) + Gp*V_i - Ib*(exp(-1.2/0.025*(V_i + Vb) - 1));
    I(i) = I_i;
    % Random variation
    I_var(i) = I_i + 0.1*r(i)*I_i;
end

figure 
subplot(2,1,1);
plot(V, I*10^12);
title("Sample data");
hold on
plot(V, I_var*10^12);
xlabel("V (V)");
ylabel("I (pA)");
legend("Ideal", "Noise");

subplot(2,1,2);
semilogy(V, abs(I*10^12));
title("Sample data Log");
hold on
semilogy(V, abs(I_var*10^12));
xlabel("V (V)");
ylabel("abs I (pA)");
legend("Ideal", "Noise");

% Polyfitting
% 4th order
Vt = V.';
p4 = polyfit(V, I_var, 4);
I4 = polyval(p4, V);

p8 = polyfit(V, I_var, 8);
I8 = polyval(p8, V);

figure 

subplot(4, 2, 1);
plot(V, I_var);
title("Sample data");
hold on
xlabel("V (V)");
ylabel("I (pA)");
ylim([-4 4])
plot(V, I4, 'LineStyle', '--');
plot(V, I8, 'LineStyle', '--');
legend("Data", "Poly4", "Poly8");

subplot(4, 2, 2);
semilogy(V, abs(I_var));
title("Sample data Log");
hold on
xlabel("V (V)");
ylabel("abs I (pA)");
semilogy(V, abs(I4), 'LineStyle', '--');
semilogy(V, abs(I8), 'LineStyle', '--');
%ylim([10E-4 10E0]);
legend("Data","Poly4", "Poly8");

% Non linear fit
% first for B and D constant
fo1 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff1 = fit(Vt,I_var,fo1);
If1 = ff1(Vt);

% second for D constant
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff2 = fit(Vt,I_var,fo2);
If2 = ff2(Vt);

% third for all params
fo3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff3 = fit(Vt,I_var,fo3);
If3 = ff3(Vt);

subplot(4, 2, 3);
plot(V, I_var);
title("Non-linear fit");
hold on
xlabel("V (V)");
ylabel("I (pA)");
ylim([-4 4])
plot(V, If1, 'LineStyle', '--');
plot(V, If2, 'LineStyle', '--');
plot(V, If3,'LineStyle', '--');
legend("Data", "fit2", "fit3", "fit4", 'Location', 'northeast');

subplot(4, 2, 4);
semilogy(V, abs(I_var));
title("Non-linear fit Log");
hold on
xlabel("V (V)");
ylabel("abs I (pA)");
semilogy(V, abs(If1),'LineStyle', '--');
semilogy(V, abs(If2), 'LineStyle', '--');
semilogy(V, abs(If3),'LineStyle', '--');
ylim([10E-5 10E0]);
legend("Data", "fit2", "fit3", "fit4");

% Neural nets
inputs = V;
targets = I_var.';

hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testratio = 15/100;
[net,tr] = train(net, inputs, targets);
outputs = net(inputs);
errors = gsubtract(outputs, targets);
performance = perform(net, targets, outputs);
view(net)
Inn = outputs;

subplot(4, 2, 5);
plot(V, I_var);
title("Neural Network");
hold on
xlabel("V (V)");
ylabel("I (pA)");
ylim([-4 4])
plot(V, Inn,'LineStyle', '--');
legend("Data", "NN");

subplot(4, 2, 6);
semilogy(V, abs(I_var));
title("Neural Network Log");
hold on
xlabel("V (V)");
ylabel("abs I (pA)");
semilogy(V, abs(Inn),'LineStyle', '--');
ylim([10E-5 10E0]);
legend("Data", "NN");

% Gaussian GPR
m = fitrgp(Vt ,I_var);

I_pred = predict(m, Vt);
s = m.Sigma; % error
a = m.Alpha; % confidence

I_up = I_pred + 2*s;
I_low = I_pred - 2*s;

% [I_pred, I_up, I_low] = predict(m, Vt);

subplot(4, 2, 7);
plot(V, I);
title("Gaussian Process Regression");
hold on
xlabel("V (V)");
ylabel("I (pA)");
ylim([-4 4])
plot(V, I_pred,'LineStyle', '--');
plot(V, I_low, 'LineStyle', '--');
plot(V, I_up, 'LineStyle', '--');
legend("Data", "RGP Mean", "RGP Lower", "RGP Upper");

subplot(4, 2, 8);
semilogy(V, abs(I));
title("Gaussian Process Regression Log");
hold on
xlabel("V (V)");
ylabel("abs I (pA)");
semilogy(V, abs(I_pred),'LineStyle', '--');
semilogy(V, abs(I_low), 'LineStyle', '--');
semilogy(V, abs(I_up),'LineStyle', '--');
%ylim([10E-4 10E0]);
legend("Data", "RGP Mean", "RGP Lower", "RGP Upper");