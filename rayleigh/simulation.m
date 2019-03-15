clear;
clc;
N=20;
fc=2.4*10^9;
Vu=3000/3600;

[r,fd]=SU_Channel(N,Vu,fc);

clf;
axis equal;
hold on;
x1=1;
y1=1;
rc=150;         % Radius of the Cell (r)
[x,y,z] = cylinder(rc,200); grid on;    % 200개의 점으로 이루어진 반지름 rc의 원 
subplot(3,1,1);
plot(x(1,:)+x1,y(1,:)+y1,'r'); hold on; grid on;
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
plot(PU(1),PU(2),'*');                       % PU의 위치 
plot(FC(1),FC(2),'sk');


Ns=10^(-9);     % Generate a Noise: -90dBm
Ps=10^(2);     % Power of PU: 20dBm
K=1;           % Path loss constant 
mu=4;          % Path loss exponent 
h_k=K./(distance.^mu); % Path loss channel model

Pr=(Ps/Ns).*h_k;    % Received Power at SU
for i=1:size(r,2)
    r2=r.^2;
    gamma(:,i)=Pr'.*r2(:,i);        % SNR of SU
end

subplot(3,1,2);
semilogy(gamma(1,:)); grid on; hold on; 

for i=1:N
   cdf(i,:)=cumsum(gamma(i,:))./max(cumsum(gamma(i,:)));
   cdf_x(i,:)=sort(gamma(i,:),'ascend');
   subplot(3,1,3);
   plot(cdf_x(i,:),cdf(i,:)); hold on; grid on;
end
