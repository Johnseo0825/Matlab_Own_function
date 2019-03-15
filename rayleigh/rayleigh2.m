function r = rayleigh2( fd, fs, Ns )
% r = rayleigh(fd,fs,N)
%
% A Rayleigh fading simulator based on Clarke's Model
% Creates a Rayleigh random process with PSD determined
% by the vehicle's speed.
%
% INPUTS:
%   fd = doppler frequency
%        set fd = v*cos(theta)/lambda
%        v = velocity (meters per second)
%        lambda = carrier wavelength (meters)
%        theta = angle w/ respect to tangent (radians).
%   fs = sample frequency (Samples per second)
%   Ns = number of samples of the Rayleigh fading
%        process to produce
%
% OUTPUTS:
%   r  = row vector containing Ns samples of the Rayleigh
%        fading process 
%
% Author:  Matthew C. Valenti
%          Mobile and Portable Radio Research Group
%          Virginia Tech    
%
% For Academic Use Only

N = 8;
while(N)
   if (N < 2*fd*Ns/fs) 
      N = 2*N;
   else
      break;
   end
end 

% number of ifft points (for smoothing)
N_inv = ceil(N*fs/(2*fd));

% determine the frequency spacings of signal after FFT
delta_f = 2*fd/N;

% determine time spacing of output samples
delta_T_inv = 1/fs;

%%%%%%%%%%% Begin Random Input Generation %%%%%%%%%%%%
% fprintf( 'Generating Input\n');
% generate a pair of TIME DOMAIN gaussian i.i.d. r.v.'s
I_input_time = randn(1,N);
Q_input_time = randn(1,N);

% take FFT
I_input_freq = fft(I_input_time);
Q_input_freq = fft(Q_input_time);

%%%  Generate Doppler Filter's Frequency Response %%%
% fprintf( 'Generating Doppler Filter Function\n');
% filter's DC component
SEZ(1) = 1.5/(pi*fd);

% 0 < f < fd 
for j=2:N/2
   f(j) = (j-1)*delta_f;
   SEZ(j) = 1.5/(pi*fd*sqrt(1-(f(j)/fd)^2));
   SEZ(N-j+2) = SEZ(j);
end

% use a polynomial fit to get the component at f = fd
% p = polyfit( f(N/2-3:N/2), SEZ(N/2-3:N/2), 3);
% SEZ(N/2+1) = polyval( p, f(N/2)+delta_f );
% k = N/2 - 1;

k = 3;
p = polyfit( f(N/2-k:N/2), SEZ(N/2-k:N/2), k );
SEZ(N/2+1) = polyval( p, f(N/2)+delta_f );

%%%%%%%% Perform Filtering Operation %%%%%%%%%%%%%%
% fprintf( 'Computing Output\n' );
% pass the input freq. components through the filter
I_output_freq = I_input_freq .* sqrt(SEZ);
Q_output_freq = Q_input_freq .* sqrt(SEZ);

% take inverse FFT
I_temp = [I_output_freq(1:N/2) zeros(1,N_inv-N) I_output_freq(N/2+1:N)];
I_output_time = ifft(I_temp);

Q_temp = [Q_output_freq(1:N/2) zeros(1,N_inv-N) Q_output_freq(N/2+1:N)];
Q_output_time = ifft(Q_temp);

% make vector of times (in milliseconds)
% for j = 1:N_inv
%   t(j) = (j-1)*delta_T_inv*1000;
% end

% take magnitude squared of each component and add together
for j=1:N_inv
   r(j) = sqrt( (abs(I_output_time(j)))^2 + (abs(Q_output_time(j)))^2);
end

% normalize and compute rms level
rms = sqrt( mean( r.*r ) );
%r = r(1:Ns)/rms;
r1=r;
r = r1(1:Ns)/rms;


% figure
% semilogy((1:Ns).*delta_T_inv, r);
% xlabel('Elapsed Time(ms)');
% ylabel('Signal Level');
% eval(['title(''The Simulated Rayleigh Fading (doppler frequency = ',num2str(fd),'200Hz)'');']);
% grid on
% 
% figure
% plot((1:Ns).*delta_T_inv, 20*log10(r));
% xlabel('Elapsed Time(ms)');
% ylabel('Signal Level');
% eval(['title(''The Simulated Rayleigh Fading (doppler frequency = ',num2str(fd),'Hz)'');']);
% grid on



AFD_LCR=0;
if AFD_LCR==1
fm=fd;
R_rms=rms;

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

%pause;

%subplot(2,1,1);
%semilogx(rho_x,Nr);
%title('The number of Level Crossing');
%xlabel('rho');

%subplot(2,1,2);
%semilogx(rho_x,tau);
%title('Average Fade Duration');
%ylabel('Duration');
%xlabel('rho');

Nr(100)
tau(100)
end

