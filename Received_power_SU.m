%==========================================================================
% 4. Received Power of SU 
%   - Consider pathloss
% 1. ������¥: 2018-0726
% 2. ��������: 1)
%
%==========================================================================

function [Pr]=Received_power_SU(PU, SU, Num_user, Pt_dBm, channel_state )
path_exp  = 4;                                 % Pathloss exponent
ref_dist  = 10;                                % Reference distance for pathloss model [m]
P_ref     = 10;                                % Pathloss at the reference distance [dB]
%Pt_dBm    = 23;
Pt        = 10*log10( 10.^(Pt_dBm/10)*10^-3 );  % 23[dBm] = 200mW = 0.2W = -6.9897[dBW]
X_shadow  = 5 ;                                 % ������ ǥ������ [dB]

%==========================================================================
% ��� PU�� SU���� �Ÿ� ���
%==========================================================================
    for k=1:size(SU,2)
        for kk=1:size(PU,2)
            % row = SU, column = PU
            sensing_dist(k,kk) = sqrt( ( SU(1,k)-PU(1,kk) ).^2 + ( SU(2,k)-PU(2,kk) ).^2 );
    %         if k==1
    %         cell_dist(1,kk) = sqrt( ( BSx_p-PU(1,kk) ).^2 + ( BSy_p-PU(2,kk) ).^2 );        
    %         % PU�� base station ������ �Ÿ� ���, �Ÿ��� ���� PU�� �۽� �Ŀ� ������ ���� 
    %         end
        end    
            %reporting_dist(k,1) = sqrt( ( SU(1,k) - 1 ).^2 + ( SU(2,k) - 1 ).^2 );
    end
        %power_ratio = cell_dist./(2*rc);
        %power_ratio(power_ratio>1) = 1;
        %Pt_adj = Pt+10*log10(power_ratio);      %[dBW], Pt_adj = 10*log10(Power_tr[W]*power_ratio)
        Pt_adj = Pt;      %[dBW], Pt_adj = 10*log10(Power_tr[W]*power_ratio)

    %==========================================================================
    % 6. ��� ���� ä�ο� ���� �� SU�� �Ÿ��� ���� ��μս��� ����� ���� �Ŀ� ���
    %==========================================================================
    for k=1:Num_user
        %n0 = wgn(Ns,Num_channel,-100,'dBm');                                                 % [W]
        P_loss(k,:) = P_ref+10*path_exp.*log10(sensing_dist(k,:)./ref_dist)+X_shadow;         % [dB]
        Pr_dBW(k,:) = Pt_adj - P_loss(k,:);                                                   % [dBW - dB = dBW]
        %Pr_dBW(k,:) = Pt - P_loss(k,:);                                                      % [dBW - dB = dBW]
        Pr_dBm(k,:) = Pt_dBm - P_loss(k,:);                                                   % [dBm - dB = dBm]
        Pr(k,:) = channel_state.*10.^(Pr_dBW(k,:)./10);                                       % [W]
        Pr_mW(k,:) = Pr(k,:).*10^3;                                                           % [mW]

    %     PU_OFF_snr_2(k,:) = 10*log10( abs( var(n0)*10^3 - 10^(P_avg_N0/10) )) - P_avg_N0;
    %     %SU_snr_2(k,find(channel_state==0)) = PU_OFF_snr_2( find(channel_state==0) );
    %     
    %     SU_rx_h(k,:) = mean(gen_SU_rx_CH(Num_channel, Ns));       % SU�� ���̵� ä�� ����; h^2 (power)������ ����
    %     %SU_rx_sig = SU_rx_h(k,:).*sqrt(Pr(k,:)) + n0;    
    %     PU_ON_snr_2(k,:) = 10*log10( abs(mean( ( SU_rx_h(k,:).*sqrt(Pr(k,:)) + n0).^2 ).*10^3 - 10^(P_avg_N0/10)) ) - P_avg_N0;
    %     %SU_snr_2(k,find(channel_state==1)) = PU_ON_snr_2( find(channel_state) );
    end

end