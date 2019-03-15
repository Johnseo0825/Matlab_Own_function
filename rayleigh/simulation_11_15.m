clear;
clc;
tic;
%% Secondary Networks
N=20;                       % ���� �� 
tau_s=1*10^(-3);            % SU�� sensing duration/1-frame [1ms]
fss=3*10^(6);               % SU�� sampling frequency [3MHz]
Nss=tau_s*fss;              % SU�� �ѹ��� sensing duration���� ��� ������ ����; [3000/s]
Vu=3000/3600;               % SU�� �ӵ�=3km/h
Ob_t=20;                    % �����ð� [40s]
frame_s=20*10^(-3);         % �� �������� ����
Tot_Ns=(Ob_t/frame_s)*Nss;  % �����ð����� ��ü �� ���� ����    


%% ä�� ����
fc=2.4*10^9;            % fc[Hz]
fs=1000;                % sampling frequency
fd=(Vu*fc)/(3*10^8);    % doppler frequency 
Ns=10^4;                % Number of channel samples

% for i=1:20
%     r(i,:)=rayleigh2(fd,fs,Ns);                              % N���� SU ä�� ����
%     No(i,:)=(randn(1,Tot_Ns)+1j.*randn(1,Tot_Ns))./sqrt(2);  % Complex Noise ~ N(0,1) ����   
% end

 for i=1:20
        r(i,:)=rayleigh2(fd,fs,Ns);                              % N���� SU ä�� ����
	for k=1:Ob_t/frame_s
        No(i,Nss*(k-1)+1:Nss*k)=(randn(1,Nss)+1j.*randn(1,Nss))./sqrt(2);  % Complex Noise ~ N(0,1) ����   
    end
end


%% Primary Network
PU_used=floor(rand(1,Ob_t/frame_s)+0.5);   % PU�� spectrum ������� 
%PU_slot=zeros(N,Tot_Ns);                  % frame_s*Nss�� ����, Block fading = quasi static, �� ������ �������� ä���� �ٲ��� ����


for i=1:Ob_t/frame_s                       % [Nss[=3000] sensing / 1-sensing duration] and Number of the frame is Ob_t/frame_s.
    
    if PU_used(i)==1;
        for j=Nss*(i-1)+1:Nss*i
            SU_rx_signal(:,j)=abs(No(:,j)+r(:,i).*(1+1j)/sqrt(2)).^2; % PU�� ������ ��� SU�� Y=S+N�� �ް� �ȴ�
        end        
    else
        for j=Nss*(i-1)+1:Nss*i
            SU_rx_signal(:,j)=abs(No(:,j)).^2;        % PU�� �������� ���� ��� SU�� Y=N�� �ް� �ȴ�
        end
    end        
    
end


for i=1:N
    
    for k=1:Ob_t/frame_s
         Mean_SU_rx(i,k)=mean(SU_rx_signal(i,Nss*(k-1)+1:Nss*k));     % �� ������ ����(1-frame=3000 sensing data)�� ��հ� ���    
    end
    
    Mean_channel_user(i)=mean(r(i,:));                                 % ������ ��ü ���� �ð������� ä�� ��հ�
    
end


% for k=1:Ob_t/frame_s
%     FC_reported(k)=sum(Mean_rx_signal(:,k));    
% end


%Threshold=sort(abs(Mean_channel_user).^2,'ascend');                             %% �� ������ ä�ΰ��� ����� ���ΰ����� ����

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



H_user=find(Mean_channel_user(1,:)==max(Mean_channel_user(1,:)));       % ä�� ��հ��� ���� ���� SU
L_user=find(Mean_channel_user(1,:)==min(Mean_channel_user(1,:)));       % ä�� ��հ��� ���� ������ SU

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