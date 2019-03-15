%==========================================================================
% Sequencial Simulation 
%   - 
% 1. 수정날짜: 2018-0726
% 2. 수정내용: 1)
%
%==========================================================================
close all;
clear; 
clc;
%hold on
addpath('D:\1. 대학원\MATLAB self code\function_module');

%Num_user = [8 12 16 20];                % Number of SU
Num_user = 20; 
%Num_channel = [4 6 8 10];               % Number of PU(licensed channel)
Num_channel = 10;                       % Number of PU(licensed channel)
Parameter_setting;
CR_and_FC_position;
tic;
for j=1:length(Num_user)
    for t=1:length(Num_channel)
        for k=1:200
            channel_state = round(rand(1,Num_channel(t)));

            [PU_p, SU_p]=PU_SU_Position(Num_channel(t), Num_user(j), rc);
            [Pr] = Received_power_SU(PU_p, SU_p, Num_user(j), 23, channel_state);
            [SU_snr, prob_d, prob_f, Local_Decision]=Calculate_SNR(Num_user(j), Num_channel(t), Ns, Pr, P_avg_N0, channel_state );

            [SNR, idx_channel] = sort(max(SU_snr),'descend');     % SU의 모든 센싱채널 중 가장 큰 SNR을 기준으로 내림차순 정렬
            prob_e = prob_f + (1-prob_d);
            [group_e, group_Pe, group_E_SNR] = group_by_error(prob_e, target_Pe, idx_channel, SU_snr);
            [group_d, group_Pd, group_D_SNR] = group_by_detection(prob_d, target_Pd, idx_channel, SU_snr);

            [Group_deci_E, Group_deci_D, Thr_E, Thr_D] = Group_Decision_Thr(Num_channel(t), group_e, group_d, Local_Decision, SU_snr, BW);
                Oppor_Thr_E(t,k,j) = sum(Thr_E.*(~channel_state));
                Oppor_Thr_D(t,k,j) = sum(Thr_D.*(~channel_state));
            [Acc, Succe_Util, False_Util, Miss_Util] = Calculate_Accuracy_Spectrum_Utilization(Group_deci_E, Group_deci_D, channel_state);
                Accuracy_E(t,k,j) = Acc(1);
                Accuracy_D(t,k,j) = Acc(2);
                Succe_Util_E(t,k,j) = Succe_Util(1);
                Succe_Util_D(t,k,j) = Succe_Util(2);
                False_Util_E(t,k,j) = False_Util(1);
                False_Util_D(t,k,j) = False_Util(2);
                Miss_Util_E(t,k,j) = Miss_Util(1);
                Miss_Util_D(t,k,j) = Miss_Util(2);
            

            
            if length(find(prob_d>=target_Pd)) > 0
                var_d(t,k,j) = var(prob_e(find(prob_d>=target_Pd)));
                max_d(t,k,j) = max(prob_e(find(prob_d>=target_Pd)));
                min_d(t,k,j) = min(prob_e(find(prob_d>=target_Pd)));
            else
            end
            
            if length(find(prob_e<=target_Pe)) > 0
                var_e(t,k,j) = var(prob_e(find(prob_e<=target_Pe)));
                max_e(t,k,j) = max(prob_e(find(prob_e<=target_Pe)));
                min_e(t,k,j) = min(prob_e(find(prob_e<=target_Pe))) ;           
            else
            end

        end
    end
end
toc;
    if length(Num_user)==1
        Accuracy_channel_variable_E(1,1:length(Num_channel)) = mean(Accuracy_E,2);
        Accuracy_channel_variable_D(1,1:length(Num_channel)) = mean(Accuracy_D,2);
        Opportunistic_channel_Throughput_E(1,1:length(Num_channel)) = mean(Oppor_Thr_E,2);
        Opportunistic_channel_Throughput_D(1,1:length(Num_channel)) = mean(Oppor_Thr_D,2);
        subplot(1,2,1)
        bar(Num_channel, [Accuracy_channel_variable_E ; Accuracy_channel_variable_D]');
        xlabel('Number of CHs'), ylabel('Sensing Accuracy'), hold on, grid on;
        legend('Proposed','Conventional');
        title(['Number of SU = ',num2str(Num_user)]);
        subplot(1,2,2)
        bar(Num_channel, [Opportunistic_channel_Throughput_E ; Opportunistic_channel_Throughput_D]');
        xlabel('Number of CHs'), ylabel('Average Opportunistic Throughput'), hold on, grid on;
        legend('Proposed','Conventional');
        title(['Number of SU = ',num2str(Num_user)]);
    else
        Accuracy_user_variable_E(1,1:length(Num_user)) = mean(Accuracy_E,2);
        Accuracy_user_variable_D(1,1:length(Num_user)) = mean(Accuracy_D,2);
        Opportunistic_user_Throughput_E(1,1:length(Num_user)) = mean(Oppor_Thr_E,2);
        Opportunistic_user_Throughput_D(1,1:length(Num_user)) = mean(Oppor_Thr_D,2);
        subplot(1,2,1)
        bar(Num_user, [Accuracy_user_variable_E ; Accuracy_user_variable_D]');
        xlabel('Number of SUs'), ylabel('Sensing Accuracy'), hold on, grid on;
        legend('Proposed','Conventional');
        title(['Number of CH = ',num2str(Num_channel)]);
        subplot(1,2,2)
        bar(Num_user, [Opportunistic_user_Throughput_E ; Opportunistic_user_Throughput_D]');
        xlabel('Number of SUs'), ylabel('Average Opportunistic Throughput'), hold on, grid on;
        legend('Proposed','Conventional');
        title(['Number of CH = ',num2str(Num_channel)]);
    end

    Var_Error(1,:) = mean(var_d,2);
    Var_Error(2,:) = mean(var_e,2);
    Max_Error(1,:) = mean(max_d,2);
    Max_Error(2,:) = mean(max_e,2);
    Min_Error(1,:) = mean(min_d,2);  
    Min_Error(2,:) = mean(min_e,2);
    
     Var_Error
     Max_Error
     Min_Error






