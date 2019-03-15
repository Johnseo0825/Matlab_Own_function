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
Ns=10^3;                % Number of channel samples


 for i=1:20
        channel=(rayleigh2(fd,fs,Ns)).^2;                              % N개의 SU 채널 생성
        r(i,:)=reshape(repmat(channel, 3000,1),1,fss);
	for k=1:Ob_t/frame_s
        %No(i,Nss*(k-1)+1:Nss*k)=(randn(1,Nss)+1j.*randn(1,Nss))./sqrt(2);  % Complex Noise ~ N(0,1) 생성   
        No(i,Nss*(k-1)+1:Nss*k)=sqrt(30).*(randn(1,Nss)+1j.*randn(1,Nss));  % Complex Noise ~ N(0,1) 생성   
    end
 end

 S=r.*(1+1j)./sqrt(2);


 
 %% Primary Network
PU_used=floor(rand(1,Ob_t/frame_s)+0.5);   % PU의 spectrum 사용유무 
%PU_slot=zeros(N,Tot_Ns);                  % frame_s*Nss번 센싱, Block fading = quasi static, 한 프레임 내에서는 채널이 바뀌지 않음

PU_slot_index=find(PU_used);               % PU가 몇번째 프레임에서 신호를 사용하는지 확인
PU_nslot_index=zeros(1,1000);              
PU_nslot_index(PU_slot_index)=1;           
PU_tot_index=reshape(repmat(PU_nslot_index,3000,1),1,3000000);  % 전체 sensing time동안 PU의 유무에 대한 indexing

%% SU networks
S(:,find(PU_tot_index==0))=0;
SU_rx_signal=abs(S+No).^2;


for i=1:N    
    for k=1:Ob_t/frame_s
         Mean_SU_rx(i,k)=mean(SU_rx_signal(i,Nss*(k-1)+1:Nss*k));    % 한 프레임 단위(3000 sensing data/frame)로 평균값 계산    
    end        
end

%% Decision Part

for i=1:1:Ob_t/frame_s
    FC_rx_SD(i)=mean(Mean_SU_rx(:,i));  % Soft decision at Fusion center    
end

%Threshold=min(FC_rx_SD)-7:(max(FC_rx_SD)-min(FC_rx_SD)+4.5)/19:max(FC_rx_SD)-2.5;
%Threshold=100.4:0.025:100.9;
Threshold=59:1:79;

for k=1:N
    SU_HD=zeros(N,Ob_t/frame_s);
    SU_HD(find(Mean_SU_rx>=Threshold(k)))=1;
    for j=1:Ob_t/frame_s
        FC_total_HD(k,j)=round(mean(SU_HD(:,j))); % 전체 유저 중 절반 이상의 decision으로 global decision을 함        
    end
    FC_total_SD(k,:)=FC_rx_SD-Threshold(k);    
end
    FC_total_SD(find(FC_total_SD>=0))=1;
    FC_total_SD(find(FC_total_SD<0))=0;


%% Calculate Probability part

Compare_slot=repmat(PU_used,20,1);
FC_SD_compare=FC_total_SD-Compare_slot;
FC_HD_compare=FC_total_HD-Compare_slot;

for k=1:20
    Pf_SD(k)=length(find(FC_SD_compare(k,:)==1))/(Ob_t/frame_s);
    Pf_HD(k)=length(find(FC_HD_compare(k,:)==1))/(Ob_t/frame_s);
    Pm_SD(k)=length(find(FC_SD_compare(k,:)==-1))/(Ob_t/frame_s);
    Pm_HD(k)=length(find(FC_HD_compare(k,:)==-1))/(Ob_t/frame_s);
end
HD_sum_P=Pm_HD+Pf_HD;
SD_sum_P=Pm_SD+Pf_SD;
HD_Pd=1-Pm_HD;
SD_Pd=1-Pm_SD;


% subplot(2,1,1);
% semilogy(Threshold(1:20),Pf_HD,'-*k'); grid on; hold on;
% semilogy(Threshold(1:20),Pm_HD,'-o'); xlabel('Thresholds'); ylabel('Probability'); 
% plot(Threshold(1:20),HD_sum_P,'LineWidth',1.5); title('Hard decision');
% plot(Threshold(find(HD_sum_P==min(HD_sum_P))),min(HD_sum_P),'ks','LineWidth',2,'MarkerSize',7,'MarkerFaceColor','g');
% legend(['P_{f,HD}'], ['P_{m,HD}'],['P_{m}+P_{f}']);
% 
% subplot(2,1,2);
% semilogy(Threshold(1:20),Pf_SD,'-.sk'); grid on; hold on;
% semilogy(Threshold(1:20),Pm_SD,'--p'); xlabel('Thresholds'); ylabel('Probability'); 
% plot(Threshold(1:20),SD_sum_P,'r','LineWidth',1.5); title('Soft decision');
% plot(Threshold(find(SD_sum_P==min(SD_sum_P))),min(SD_sum_P),'ks','LineWidth',2,'MarkerSize',7,'MarkerFaceColor','g');
% legend(['P_{f,SD}'],['P_{m,SD}'],['P_{m}+P_{f}']);

subplot(2,1,1);
plot(Threshold(1:20),Pf_HD,'-*k'); grid on; hold on;
plot(Threshold(1:20),Pm_HD,'-o'); xlabel('Thresholds'); ylabel('Probability'); 
plot(Threshold(1:20),HD_sum_P,'r','LineWidth',1.5); title('Hard decision');
plot(Threshold(find(HD_sum_P==min(HD_sum_P))),min(HD_sum_P),'ks','LineWidth',2,'MarkerSize',7,'MarkerFaceColor','g');
legend(['P_{f,HD}'], ['P_{m,HD}'],['P_{m}+P_{f}']);

subplot(2,1,2);
plot(Threshold(1:20),Pf_SD,'-.sk'); grid on; hold on;
plot(Threshold(1:20),Pm_SD,'--p'); xlabel('Thresholds'); ylabel('Probability'); 
plot(Threshold(1:20),SD_sum_P,'r','LineWidth',1.5); title('Soft decision');
plot(Threshold(find(SD_sum_P==min(SD_sum_P))),min(SD_sum_P),'ks','LineWidth',2,'MarkerSize',7,'MarkerFaceColor','g');
legend(['P_{f,SD}'],['P_{m,SD}'],['P_{m}+P_{f}']);


toc;














