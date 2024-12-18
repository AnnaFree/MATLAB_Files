T = 1;
t = linspace(0, T, 1000);
%signal definition
x1 = sin(2* pi * t + pi/3);
x2 = sin(2* pi  * t - pi/3);

N = 10;
a1 = zeros(1, N);
b1 = zeros(1, N);
a2 = zeros(1,N);
b2 = zeros(1, N);

for k =1:N
    initialCos = cos(2*pi*k*t);
    initialSin = sin(2* pi * k * t);
    a1(k) = 2/T * trapz(t, x1 .* initialCos);
    b1(k) = 2/T * trapz(t, x1 .* initialSin);
    a2(k) = 2/T * trapz(t, x1 .* initialCos);
    b2(k) = 2/T * trapz(t, x1 .* initialSin);
end

    A1 = sqrt(a1.^2 + b1.^2); % Amplitude 
    phi1 = atan2(b1, a1); 
    A2 = sqrt(a2.^2 + b2.^2); 
    phi2 = atan2(b2, a2); 
    % test print
    fprintf('Amplitude and Phase for x1 (Positive Shift):\n'); 
    disp([A1; phi1]); 
    fprintf('Amplitude and Phase for x2 (Negative Shift):\n'); 
    disp([A2; phi2]); 
    mean_values = [0, 0.5, 1]; % Different mean values to analyze 
    for i = 1:length(mean_values) 
        mean_val = mean_values(i); 
        random_signal = randn(size(t)) + mean_val; 
        a_rand = zeros(1, N); 
        b_rand = zeros(1, N); 
        for k = 1:N 
            a_rand(k) = (2/T) * trapz(t, random_signal .* cos(2 * pi * k * t)); 
            b_rand(k) = (2/T) * trapz(t, random_signal .* sin(2 * pi * k * t)); 
        end
        fprintf('Fourier coefficients for random signal with mean = %.2f:\n', mean_val); 
        disp([a_rand; b_rand]); 
    end