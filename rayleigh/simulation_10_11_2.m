clear;
clc;
N=20;
fc=2.4*10^9;
Vu=3000/3600;           % SU의 속도=3km/h

fd=(Vu*fc)/(3*10^8);     % doppler frequency 
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
[x,y,z] = cylinder(rc,200);  % 200개의 점으로 이루어진 반지름 rc의 원 
%subplot(3,1,1);
%plot(x(1,:)+x1,y(1,:)+y1,'r'); hold on; grid on;
Position=zeros(2,N);                    % N개의 SU의 위치
PU=[1000, 0];                       % PU와 SU 사이의 거리 
FC=[0, 0];

for t=1:N %loop until doing 1000 points inside the circle
[x y]=cirrdnPJ(x1,y1,rc); hold on;
distance(1,t)=sqrt((PU(1)-x)^2+(PU(2)-y)^2);
Position(1,t)=x;
Position(2,t)=y;
%plot(x,y,'x'); hold on;
%pause(0.01) %if you want to see the point being drawn
end
%plot(PU(1),PU(2),'*');                       % PU의 위치 
%plot(FC(1),FC(2),'sk');


%% Calculate the Received power of SU while PU's operation
PU_used=floor(rand(1,Ns/10)+0.5);   % PU의 spectrum 사용유무 
PU_slot=zeros(20,Ns);

Pn=10^(-9);     % Generate a Noise: -90dBm
Ps=10^(2);     % Power of PU: 20dBm
K=1;           % Path loss constant 
mu=4;          % Path loss exponent 
h_k=K./(distance.^mu); % Path loss channel model

Pr1=(Ps/Pn).*h_k;    % Received Power at SU while PU use spectrum
Pr0=(1/Pn).*h_k;    % Received Power at SU while PU dont use spectrum

for i=1:Ns/10
    
    if PU_used(i)==1;
        for j=10*i-9:10*i
            PU_slot(:,j)=Pr1';
        end
    else
        for j=10*i-9:10*i
            PU_slot(:,j)=Pr0';
        end
    end
    
end

gamma=PU_slot.*r2;