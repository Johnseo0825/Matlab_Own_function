function [group, group_Pe, group_SNR]=group_by_error(prob_e, target_Pe, idx_channel, SU_snr)    
Num_channel = size(prob_e,2);
Num_user = size(prob_e,1);

for k=1:Num_channel
    [error, idx_error]=sort( prob_e(:,idx_channel(k)) , 'ascend');
    bar_error = 1 - error;
        
        for i=1:Num_user
            prob_bar_error(i,idx_channel(k)) = 1 - prod( bar_error(1:i),1 );
        end
        
        idx_user_length = min( find( prob_bar_error(:,idx_channel(k)) <= target_Pe ) );
        
        if length(idx_user_length)==0
            group(1, idx_channel(k) ) = idx_error(1);
            group_SNR( 1, idx_channel(k) ) = SU_snr(idx_error(1), idx_channel(k));
            group_Pe(1, idx_channel(k)) = error(1);
            prob_e(idx_error(1),:)    = 1;
        else
            group( 1:idx_user_length, idx_channel(k) ) = idx_error(1:idx_user_length);
            group_SNR( 1:idx_user_length, idx_channel(k) ) = SU_snr(idx_error(1:idx_user_length), idx_channel(k));
            group_Pe(1:idx_user_length, idx_channel(k)) = error(1:idx_user_length);
            prob_e( idx_error(1:idx_user_length), : ) = 1;
        end        
end
    ambiguous_channel = find( group(1,:) == 0 );
    remain_user = find( prob_e(:,1)<1);
    
if length(ambiguous_channel)~=0                         % SU�� �Ҵ���� ���� ä���� �����Ҷ�
    for tt=1:length(ambiguous_channel)
        if length(find(remain_user))~=0                 % �Ҵ��� �� �ִ� SU�� �����Ҷ�             
            for kk=1:length(remain_user)
                [remain_error, idx_remain_error]=sort(prob_e(:, ambiguous_channel(tt)),'ascend');
                end_idx = length( find( group(:,ambiguous_channel(tt)) ) );
                group(end_idx+1, ambiguous_channel(tt)) = remain_user(kk);
                group_Pe(end_idx+1, ambiguous_channel(tt)) = prob_e(remain_user(kk),ambiguous_channel(tt));
                group_SNR(end_idx+1, ambiguous_channel(tt)) = SU_snr(remain_user(kk),ambiguous_channel(tt));
                prob_e(remain_user(kk),:) = 1;
                remain_user(kk) = 0;
            end
        else                                            % �Ҵ��� �� �ִ� SU�� ������
        end
    end
else                                                    % ��� ä�ο� SU�� �Ҵ������    
%         if length(find(remain_user))~=0                 % �Ҵ��� �� �ִ� SU�� �����Ҷ�
%             for kk=1:length(remain_user)
%                 [remain_error, idx_remain_error]=sort(prob_e(remain_user(kk),:),'ascend');
%                 end_idx = length( find( group(:,idx_remain_error(1)) ) );                        
%                 group(end_idx+1, idx_remain_error(1)) = remain_user(kk);
%                 group_Pe(end_idx+1, idx_remain_error(1)) = prob_e(remain_user(kk),idx_remain_error(1));
%                 group_SNR(end_idx+1, idx_remain_error(1)) = SU_snr(remain_user(kk), idx_remain_error(1));
%                 prob_e(remain_user(kk),:) = 1;
%                 remain_user(kk) = 0;
%             end
%         else                                            % �Ҵ��� �� �ִ� SU�� ������
%         end    
end

end