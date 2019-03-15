
% Rayleigh Fading Simulation
%
% Doppler frequency fm = 200Hz.
% The number of samples in frequency is 1024.
% The output plot has been drawn only by 300 samples.

fm = 200;
N = 2^10;
Ns = 1000;
delta_f = 2*fm/N;
delta_t = [1:1:N]./(2*9*fm).*1000;

% Complex Gaussian Generation

Gaussian_1 = randn(1,N/2) + j*randn(1,N/2);
Gaussian_1_conjugate = conj(Gaussian_1);
Gaussian_2 = randn(1,N/2) + j*randn(1,N/2);
Gaussian_2_conjugate = conj(Gaussian_2);

I_in_freq = [Gaussian_1 fliplr(Gaussian_1_conjugate)];
Q_in_freq = [Gaussian_2 fliplr(Gaussian_2_conjugate)];

% U-shape doppler power spectrum

SEZ(1) = 1.5/(pi*fm);

for j=2:N/2
   f(j) = (j-1)*delta_f;
   SEZ(j) = 1.5/(pi*fm*sqrt(1-(f(j)/fm)^2));
   SEZ(N-j+2) = SEZ(j);
end

k = 3;
p = polyfit( f(N/2-k:N/2), SEZ(N/2-k:N/2), k );
SEZ(N/2+1) = polyval( p, f(N/2)+delta_f );

I_out_freq = I_in_freq .* sqrt(SEZ);
Q_out_freq = Q_in_freq .* sqrt(SEZ);

I_out_freq1 = [ zeros(1,4096), I_out_freq, zeros(1,4096)];
Q_out_freq1 = [ zeros(1,4096), Q_out_freq, zeros(1,4096)];

N = N + 4096*2;

I_out_time1 = ifft(I_out_freq1);
Q_out_time1 = ifft(Q_out_freq1);

% The Envelope becomes Rayleigh

r1 = abs(sqrt((I_out_time1).^2 + (Q_out_time1).^2));
R_rms = norm(r1)/sqrt(N);
r = r1(1:Ns)/R_rms;
rho_index = 0;

for rho=0.01:0.01:1
rho_index = rho_index + 1;   
rho_x(rho_index) = rho;

Nr_num = 0;
count_s = 0;
count_e = 0;
start_d = 0;
end_d = 0;
start_d1 = 0;
end_d1 = 0;
last = 0;

% The number of level crossing rate
   
R = R_rms*rho;
I = find(r1 > R);
c = size(I);
for j=2:c(2)
   if r1(I(j)-1) < R
      Nr_num = Nr_num + 1;
   end
end
Nr(rho_index) = Nr_num*delta_f;

% Average Fading Duration
x = r1 - (R_rms * rho);
for i=1:N-1
    if x(i) > 0
        if x(i+1) <= 0
           start_d = start_d + i+x(i)/(x(i)-x(i+1));
           start_d1 = start_d1 + i;
           count_s = count_s + 1;
           debug_start_d(count_s) = start_d;
           debug_start_d1(count_s) = start_d1;
           last = i+x(i)/(x(i)+x(i+1));
        end
    elseif x(i) < 0
        if x(i+1) >= 0
                end_d = end_d + i-x(i)/(x(i+1)-x(i));
                end_d1 = end_d1 + i;                
                count_e = count_e + 1;
                debug_end_d(count_e) = end_d;                
                debug_end_d1(count_e) = end_d1;
        end
    end
end

if x(1) > 0
    if count_s > count_e
        start_d = start_d - last;
    end
 elseif x(1) < 0
    if count_s == count_e
       end_d = end_d + N;
    end
end
   
tau(rho_index) = ((end_d - start_d)/count_s)/(2*9*fm);

end

figure;
semilogy(delta_t(1:Ns), r);
xlabel('Elapsed Time(ms)');
ylabel('Signal Level');
title('The Simulated Rayleigh Fading (doppler frequency = 200Hz)');

figure;
subplot(2,1,1);
semilogx(rho_x,Nr);
title('The number of Level Crossing');
xlabel('rho');

subplot(2,1,2);
semilogx(rho_x,tau);
title('Average Fade Duration');
ylabel('Duration');
xlabel('rho');



