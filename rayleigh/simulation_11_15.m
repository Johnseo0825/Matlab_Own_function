clear;
clc;
tic;
%% Secondary Networks
N=20;                       % 유저 수 
tau_s=1*10^(-3);            % SU의 sensing duration/1-frame [1ms]
fss=3*10^(6);               % SU의 sampling frequency [3MHz]
Nss=tau_s*fss;              % SU가 한번의 sensing duration동안 얻는 샘플의 갯수; [3000/s]
Vu=3000/3600;               % SU의 속도=3km/h
Ob_t=20;                    % 관측시간 [40s]
frame_s=20*10^(-3);         % 한 프레임의 길이
Tot_Ns=(Ob_t/frame_s)*Nss;  % 관측시간동안 전체 총 샘플 갯수    


%% 채널 생성
fc=2.4*10^9;            % fc[Hz]
fs=1000;                % sampling frequency
fd=(Vu*fc)/(3*10^8);    % doppler frequency 
Ns=10^4;                % Number of channel samples

% for i=1:20
%     r(i,:)=rayleigh2(fd,fs,Ns);                              % N개의 SU 채널 생성
%     No(i,:)=(randn(1,Tot_Ns)+1j.*randn(1,Tot_Ns))./sqrt(2);  % Complex Noise ~ N(0,1) 생성   
% end

 for i=1:20
        r(i,:)=rayleigh2(fd,fs,Ns);                              % N개의 SU 채널 생성
	for k=1:Ob_t/frame_s
        No(i,Nss*(k-1)+1:Nss*k)=(randn(1,Nss)+1j.*randn(1,Nss))./sqrt(2);  % Complex Noise ~ N(0,1) 생성   
    end
end


%% Primary Network
PU_used=floor(rand(1,Ob_t/frame_s)+0.5);   % PU의 spectrum 사용유무 
%PU_slot=zeros(N,Tot_Ns);                  % frame_s*Nss번 센싱, Block fading = quasi static, 한 프레임 내에서는 채널이 바뀌지 않음


for i=1:Ob_t/frame_s                       % [Nss[=3000] sensing / 1-sensing duration] and Number of the frame is Ob_t/frame_s.
    
    if PU_used(i)==1;
        for j=Nss*(i-1)+1:Nss*i
            SU_rx_signal(:,j)=abs(No(:,j)+r(:,i).*(1+1j)/sqrt(2)).^2; % PU가 존재할 경우 SU는 Y=S+N을 받게 된다
        end        
    else
        for j=Nss*(i-1)+1:Nss*i
            SU_rx_signal(:,j)=abs(No(:,j)).^2;        % PU가 존재하지 않을 경우 SU는 Y=N을 받게 된다
        end
    end        
    
end


for i=1:N
    
    for k=1:Ob_t/frame_s
         Mean_SU_rx(i,k)=mean(SU_rx_signal(i,Nss*(k-1)+1:Nss*k));     % 한 프레임 단위(1-frame=3000 sensing data)로 평균값 계산    
    end
    
    Mean_channel_user(i)=mean(r(i,:));                                 % 유저별 전체 관측 시간동안의 채널 평균값
    
end


% for k=1:Ob_t/frame_s
%     FC_reported(k)=sum(Mean_rx_signal(:,k));    
% end


%Threshold=sort(abs(Mean_channel_user).^2,'ascend');                             %% 각 유저의 채널값의 평균을 문턱값으로 설정

%% Decision part(Soft & Hard)

for i=1:1:Ob_t/frame_s      
      SU_decision_sf(i)=mean(Mean_SU_rx(:,i));        
end

%Threshold=mean(SU_decision_sf):0.15:3*mean(SU_decision_sf);
Threshold=min(SU_decision_sf):(max(SU_decision_sf)-min(SU_decision_sf))/19:max(SU_decision_sf);

for k=1:20                                                               
    SU_decision_HD=zeros(size(Mean_SU_rx,1),size(Mean_SU_rx,2));
    FC_decision_hd=zeros(1,size(Mean_SU_rx,2));
    FC_decision_sf=zeros(1,size(Mean_SU_rx,2));
        
    SU_decision_HD(find(Mean_SU_rx>=Threshold(k)))=1;
    %HD_decision(find(abs(Mean_rx_signal)<Threshold(k)))=0;
    
    for i=1:1:Ob_t/frame_s
      FC_decision_hd(i)=mean(SU_decision_HD(:,i));                
    end
  
    FC_decision_sf(find(SU_decision_sf>=Threshold(k)))=1;
    %FC_decision_sf(find(SF_decision<Threshold(k)))=0;
    
    Pf_SD(k)=length(find((FC_decision_sf-PU_used)==1))/(Ob_t/frame_s);
    Pf_HD(k)=length(find((FC_decision_hd-PU_used)==1))/(Ob_t/frame_s);
    
    Pm_SD(k)=length(find((FC_decision_sf-PU_used)==-1))/(Ob_t/frame_s);
    Pm_HD(k)=length(find((FC_decision_hd-PU_used)==-1))/(Ob_t/frame_s);
    
end



H_user=find(Mean_channel_user(1,:)==max(Mean_channel_user(1,:)));       % 채널 평균값이 제일 좋은 SU
L_user=find(Mean_channel_user(1,:)==min(Mean_channel_user(1,:)));       % 채널 평균값이 제일 안좋은 SU

subplot(4,1,1);
semilogy(abs(SU_rx_signal(H_user,1:(Ob_t/frame_s)))); hold on; grid on; 
semilogy(abs(SU_rx_signal(L_user,1:(Ob_t/frame_s)))); 
legend(['h_{max}user=' num2str(Mean_channel_user(1,H_user))],['h_{min}user=' num2str(Mean_channel_user(1,L_user))]);
title('Abs value for every sensing time ');
xlabel('ms');

subplot(4,1,2);
semilogy(abs(Mean_SU_rx(H_user,1:(Ob_t/frame_s)/10))); grid on; hold on;
semilogy(abs(Mean_SU_rx(L_user,1:(Ob_t/frame_s)/10))); 
semilogy(PU_used(1:(Ob_t/frame_s)/10),'ro');
legend(['h_{max}user=' num2str(Mean_channel_user(1,H_user))],['h_{min}user=' num2str(Mean_channel_user(1,L_user))],['PU used']);
title('Average abs value for each sensing duration');
xlabel('Sensing duration');

subplot(4,1,3);
plot(Threshold(1:20),Pf_HD,'-*k'); grid on; hold on;
plot(Threshold(1:20),Pm_HD,'-o'); xlabel('Thresholds'); ylabel('Hard Decision'); 
legend(['P_{f,HD}'], ['P_{m,HD}']);

subplot(4,1,4);
plot(Threshold(1:20),Pf_SD,'-.sr'); grid on; hold on;
plot(Threshold(1:20),Pm_SD,'--p'); xlabel('Thresholds'); ylabel('Soft Decision'); 
legend(['P_{f,SD}'],['P_{m,SD}']);

  


toc;