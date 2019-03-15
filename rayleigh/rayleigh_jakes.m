%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Rayleigh Fading simulator %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% by Clarke's Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

Sam=2000; % Sample number, need 2 sec
n=2000; % Number of gaussian variable (Large Number)

% doppler freq fd %%%%%%%%%%%%%
fd = [20 200];
f1m=fd(1).*cos(2*pi*rand(1,n));
f2m=fd(2).*cos(2*pi*rand(1,n));

% q: uniformly distributed phase [0, 2*pi] %%%%%%%%%%%%%%%%
% C: a real random variable sum(C^2)=1
C_unnorm = rand(1,n);
C = C_unnorm/sqrt(sum(C_unnorm.^2));
q=2*pi*rand(1,n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% r(t) = ri(t)cos(2*pi*fc)-rq(t)sin(2*pi*fc)
%% ri(t) = sum(Cn*cos(2*pi*fd+q))
%% rq(t) = sum(Cn*sin(2*pi*fd+q))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% to make 8192 samples => in Time duration 8192/(2*20)=204.8000
t=[1:Sam]*200/8192;

% for fd=20
for i=1:Sam
    ri(i)=sum(C.*cos(2*pi*f1m*t(i)+q));
    rq(i)=sum(C.*cos(2*pi*f1m*t(i)+q));
    r(i)=sqrt(ri(i)^2+rq(i)^2);
end

figure;
plot(t,10*log(r));
title('fd=20Hz');
xlabel('second');
ylabel('dB');


%%for fd=200
for i=1:Sam
    ri(i)=sum(C.*cos(2*pi*f2m*t(i)+q));
    rq(i)=sum(C.*cos(2*pi*f2m*t(i)+q));
    r(i)=sqrt(ri(i)^2+rq(i)^2);
end

figure;
plot(t,10*log(r));
title('fd=200');
xlabel('second');
ylabel('dB');


