%==========================================================================
% Calculate Sensing Accuracy and Spectrum Utilization
%   - Calculate the group sensing Accuracy and Spectrum Utilization 
% 1. 수정날짜: 2018-0726
% 2. 수정내용:   1) 
%
%
%==========================================================================

function [Acc, Succe_Util, False_Util, Miss_Util]=Calculate_Accuracy_Spectrum_Utilization(Group_decision_E, Group_decision_D, channel_state)
     Accuracy_E = (1-0.25*length(find( xor(Group_decision_E,channel_state) )));
     Accuracy_D = (1-0.25*length(find( xor(Group_decision_D,channel_state) )));     
     
     Succe_Util_E = length(find((Group_decision_E+channel_state)==0));     
     False_Util_E = length(find((Group_decision_E-channel_state)==1));
     Miss_Util_E  = length(find((channel_state-Group_decision_E)==1));
%      succs_Gr_Th_E(kkk)  = sum(Rate_E.*((Group_decision_E+channel_state)==0));
%      false_Gr_Th_E(kkk)  = sum(Rate_E.*((Group_decision_E-channel_state)==1));
%      miss_Gr_Th_E(kkk)  = sum(Rate_E.*((channel_state-Group_decision_E)==1));
          
     Succe_Util_D   = length(find((Group_decision_D+channel_state)==0));
     False_Util_D = length(find((Group_decision_D-channel_state)==1));
     Miss_Util_D  = length(find((channel_state-Group_decision_D)==1));  
%      succs_Gr_Th_D(kkk)  = sum(Rate_D.*((Group_decision_D+channel_state)==0));
%      false_Gr_Th_D(kkk)  = sum(Rate_D.*((Group_decision_D-channel_state)==1));
%      miss_Gr_Th_D(kkk)  = sum(Rate_D.*((channel_state-Group_decision_D)==1));

%     Used_channel_idx_E = find( (Succe_Util_E + False_Util_E + Miss_Util_E) > 0);
%     Used_channel_idx_D = find( (Succe_Util_D + False_Util_D + Miss_Util_D) > 0);
    
    %Spectrum_utilization_E = mean( Succe_Util_E(Used_channel_idx_E) / (Succe_Util_E(Used_channel_idx_E) + False_Util_E(Used_channel_idx_E) + Miss_Util_E(Used_channel_idx_E)) );
    %Spectrum_utilization_D = mean( Succe_Util_D(Used_channel_idx_D) / (Succe_Util_D(Used_channel_idx_D) + False_Util_D(Used_channel_idx_D) + Miss_Util_D(Used_channel_idx_D)) );
    
%     Opportunity_Th_E =  Succe_Util_E(Used_channel_idx_E);
%     Opportunity_Th_D =  Succe_Util_D(Used_channel_idx_D);    
    
    Acc(1,:) = Accuracy_E;
    Acc(2,:) = Accuracy_D;    
    Succe_Util(1,:) = Succe_Util_E;
    Succe_Util(2,:) = Succe_Util_D;
    False_Util(1,:) = False_Util_E;
    False_Util(2,:) = False_Util_D;
    Miss_Util(1,:) = Miss_Util_E;
    Miss_Util(2,:) = Miss_Util_D;    
end