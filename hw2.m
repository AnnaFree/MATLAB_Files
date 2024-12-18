dt = 0.01;
T = 1;
t = [0:dt:T]';
omega0 = 2 * pi / T;
N = length(t);
N2 = round(N/2);

% Regular 7.1 with additons
x = sin(2 * pi * t) + 0.5 * sin(4 * 2 * pi * t);
a(1) = 1/T * (sum(x) * dt);
xfs = a(1) * ones(size(x));
for k = 1:10
    ck = cos(k * omega0 * t);
    a(k + 1) = 2/T * (sum(x .* ck) * dt);
    sk = sin(k * omega0 * t);
    b(k + 1) = 2/T * (sum(x .* sk) * dt);
    xfs = xfs + a(k + 1) * cos(k * omega0 * t) + b(k + 1) * sin(k * omega0 * t);
end
figure;
subplot(2,1,1);
plot(t, x, '-', t, xfs, ':');
legend('Original', 'Approximation');
title('sine wave');
xlabel('Time (s)');
ylabel('Amplitude');
% Fourier coefficients
subplot(2,1,2);
stem(0:10, [a(1), sqrt(a(2:end).^2 + b(2:end).^2)]);
title('Fourier Coefficients');
xlabel('k');
ylabel('Magnitude');
x = cos(2 * pi * t) + 2 * sin(2 * pi * t);
a(1) = 1/T * (sum(x) * dt);
xfs = a(1) * ones(size(x));

%7.4 setup
for k = 1:10
    ck = cos(k * omega0 * t);
    a(k + 1) = 2/T * (sum(x .* ck) * dt);
    sk = sin(k * omega0 * t);
    b(k + 1) = 2/T * (sum(x .* sk) * dt);
    xfs = xfs + a(k + 1) * cos(k * omega0 * t) + b(k + 1) * sin(k * omega0 * t);
end

figure;
subplot(2,1,1); 
plot(t, x, '-', t, xfs, ':');
title('Sine and cosine waveform');
legend('Original', 'Approximation');
xlabel('Time (s)');
ylabel('Amplitude');
% Fourier coefficients addition to graph
subplot(2,1,2); 
stem(0:10, [a(1), sqrt(a(2:end).^2 + b(2:end).^2)]);
title('Fourier Coefficients');
ylabel('Magnitude');
xlabel('k');