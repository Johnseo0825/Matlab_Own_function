function [gamma,fd]=SU_Channel(number_user, velocity_user, fc)

N=number_user;
fd=(velocity_user*fc)/(3*10^8);     % doppler frequency 
                                    % velocity_user[m/s]
                                    % fc[Hz]
fs=1000;                            % Sensing duration (tau_s)
Ns=10^4;                            % Number of samples
r=zeros(N,Ns);

for i=1:20
    r(i,:)=rayleigh2(fd,fs,Ns); % N개의 SU 채널 생성
                                    %
end
r2=r.^2;

%% Set the distance between PU and SU
x1=1;
y1=1;
rc=150;         % Radius of the Cell (r)
[x,y,z] = cylinder(rc,200); grid on;    % 200개의 점으로 이루어진 반지름 rc의 원 
%subplot(3,1,1);
%plot(x(1,:)+x1,y(1,:)+y1,'r'); hold on; grid on;
Position=zeros(2,N);                    % N개의 SU의 위치
PU=[1000, 0];
FC=[0, 0];

for t=1:N %loop until doing 1000 points inside the circle
[x y]=cirrdnPJ(x1,y1,rc); hold on;
distance(1,t)=sqrt((PU(1)-x)^2+(PU(2)-y)^2);
Position(1,t)=x;
Position(2,t)=y;
plot(x,y,'x'); hold on;
%pause(0.01) %if you want to see the point being drawn
end
%plot(PU(1),PU(2),'*');                       % PU의 위치 
%plot(FC(1),FC(2),'sk');

%% Calculate the Received power of SU while PU's operation
PU_used=floor(rand(1,Ns/10)+0.5);   % PU의 spectrum 사용유무 

Ns=10^(-9);     % Generate a Noise: -90dBm
Ps=10^(2);     % Power of PU: 20dBm
K=1;           % Path loss constant 
mu=4;          % Path loss exponent 
h_k=K./(distance.^mu); % Path loss channel model

Pr1=(Ps/Ns).*h_k;    % Received Power at SU while PU use spectrum
Pr0=(1/Ns).*h_k;    % Received Power at SU while PU dont use spectrum

for i=1:size(r,2)/10        % 10 samples / sensing
    
    if PU_used(i)==1
        gamma(:,10*i-9:10*i)=Pr1'.*r2(:,10*i-9:10*i);        % SNR of SU while PU use the spectrum
    else
        gamma(:,10*i-9:10*i)=Pr0'.*r2(:,10*i-9:10*i);        % SNR of SU while PU dont use the spectrum 
    end
    
end



end
