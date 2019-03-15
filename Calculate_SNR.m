%==========================================================================
% 5. Calculate SNR and Decision
%   - Consider pathloss
% 1. 수정날짜: 2018-0726
% 2. 수정내용: 1)
%
%==========================================================================

function [SU_snr, prob_d, prob_f, Decision]=Calculate_SNR(Num_user, Num_channel, Ns, Pr, P_avg_N0, channel_state )

    addpath('D:\1. 대학원\MATLAB self code\function_module');
    %==========================================================================
    % 7. 센싱채널에 대한 각 SU의 average SNR 계산 
    %==========================================================================
    for k=1:Num_user    
        n0(:,:,k) = wgn(Ns,Num_channel,-100,'dBm');
        SU_channel(k,:) = mean(gen_SU_rx_CH(Num_channel, Ns));                  % SU의 페이딩 채널 생성
        SU_rx_sig = repmat(SU_channel(k,:).*sqrt(Pr(k,:)),Ns,1) + n0(:,:,k);   
        SU_rx_energy(k,:) = mean(SU_rx_sig.^2);                                 % Ns 샘플의 평균

        SU_rx_hx2(k,:) = (SU_channel(k,:).*sqrt(Pr(k,:))).^2;
        SU_rx_N(k,:)   = var(n0(:,:,k));    
    %     
    %     SU_snr(k,find(channel_state==1)) = SU_rx_hx2(k,find(channel_state==1));
    %     SU_snr(k,find(channel_state==0)) = SU_rx_N(k,find(channel_state==0));    

        SU_snr(k,find(channel_state==1)) = SU_rx_energy(k,find(channel_state==1));
        SU_snr(k,find(channel_state==0)) = SU_rx_N(k,find(channel_state==0));    
        SU_snr(k,:) = 10*log10(SU_snr(k,:).*10^3) - P_avg_N0;


    var_N0(k,:) = var(n0(:,:,k)); 
    mu_H0(k,:) = var_N0(k,:);
    mu_H1(k,:) = ( 1 + 10.^(SU_snr(k,:)./10) ).*var_N0(k,:);
    var_H0(k,:) = var_N0(k,:).^2./Ns;
    var_H1(k,:) = (2.*10.^(SU_snr(k,:)./10) + 1).*( var_N0(k,:).^2 ./ Ns );

    % var_N0_2(k,1:Num_channel) = (10.^(P_avg_N0/10)*10^-3);
    % mu_H0_2(k,:) = var_N0_2(k,:);
    % mu_H1_2(k,:) = ( 1 + 10.^(SU_snr(k,:)./10) ).*var_N0_2(k,:);
    % var_H0_2(k,:) = var_N0_2(k,:).^2./Ns;
    % var_H1_2(k,:) = (2.*10.^(SU_snr(k,:)./10) + 1).*( var_N0_2(k,:).^2 ./ Ns );

    end
    
    [min_error_th, SNRdB] = Cal_MSSE_Threshold(Ns, P_avg_N0, max(max(SU_snr)),min(min(SU_snr)));
    
    for k=1:Num_user
    %noise = var(n0(:,:,k));
    %SU_rx_pow(k,find(channel_state==0)) = noise(find(channel_state==0));
        for kk=1:Num_channel
            idx_th = max(find(SU_snr(k,kk) > SNRdB));
            SU_th(k,kk) = min_error_th(idx_th);
        end
    end

    prob_d = qfunc( (SU_th - mu_H1)./sqrt(var_H1) );
    prob_m = 1-prob_d;
    prob_f = qfunc( (SU_th - mu_H0)./sqrt(var_H0) );
    %prob_s = 1 - prob_f;
    %prob_e = prob_m + prob_f;
    
    % prob_d_2 = qfunc( (SU_th - mu_H1_2)./sqrt(var_H1_2) );
    % prob_f_2 = qfunc( (SU_th - mu_H0_2)./sqrt(var_H0_2) );
    % prob_e_2 = (1-prob_d_2) + prob_f_2;

    Decision=(SU_rx_energy>SU_th);

end

