%==========================================================================
% Cooperative Group Decision and Throughput
%   - Calculate the group decision and Throughput
% 1. 수정날짜: 2018-0726
% 2. 수정내용:   1) 
%
%
%==========================================================================

function [Group_decision_E, Group_decision_D, Group_Thr_E, Group_Thr_D]=Group_Decision_Thr(Num_channel, group_e, group_d, Decision, SU_snr, BW)
        Rate = max(BW*log10(1+10.^(SU_snr./10)));        

%     Group_decision_Error = zeros(1,Num_channel);
%     Group_decision_Detect = zeros(1,Num_channel);

          for k=1:Num_channel
            Group_decision_Error(1:length(find(group_e(:,k))),k) = Decision(group_e(1:length(find(group_e(:,k))),k),k);
            Group_decision_Detect(1:length(find(group_d(:,k))),k) = Decision(group_d(1:length(find(group_d(:,k))),k),k);
          end

         Group_decision_E = sum(Group_decision_Error,1);
         Group_decision_D = sum(Group_decision_Detect,1);
         Group_decision_E(Group_decision_E>1) = 1;
         Group_decision_D(Group_decision_D>1) = 1;
         Group_Thr_E = Rate.*(~Group_decision_E);
         Group_Thr_D = Rate.*(~Group_decision_D);
end