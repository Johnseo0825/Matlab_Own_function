function [group, group_Pd, prob_d, group_SNR]=group_by_detection(prob_d, target_Pd, idx_channel, SU_snr)    
Num_channel = size(prob_d,2);
Num_user = size(prob_d,1);

for k=1:Num_channel
    [detect, idx_detect]=sort( prob_d(:,idx_channel(k)) , 'descend');
    bar_detect = 1 - detect;
        
        for i=1:Num_user
            prob_bar_detect(i,idx_channel(k)) = 1 - prod( bar_detect(1:i),1 );
        end
        
        idx_user_length = min( find( prob_bar_detect(:,idx_channel(k)) >= target_Pd ) );
        
            if length(idx_user_length)==0
                group(1, idx_channel(k) ) = idx_detect(1);
                group_SNR( 1, idx_channel(k) ) = SU_snr(idx_detect(1), idx_channel(k));
                group_Pd(1, idx_channel(k)) = detect(1);
                prob_d(idx_detect(1),:)    = 0;
            else
                group( 1:idx_user_length, idx_channel(k) ) = idx_detect(1:idx_user_length);
                group_SNR( 1:idx_user_length, idx_channel(k) ) = SU_snr(idx_detect(1:idx_user_length), idx_channel(k));
                group_Pd(1:idx_user_length, idx_channel(k)) = detect(1:idx_user_length);        
                prob_d( idx_detect(1:idx_user_length), : ) = 0;
            end    
end

    ambiguous_channel = find( group(1,:) == 0 );
    remain_user = find( prob_d(:,1)>0);
    
    if length(ambiguous_channel)~=0         % SU가 할당되지 않은 채널이 존재할때
        for tt=1:length(ambiguous_channel)
            if length(find(remain_user))~=0                   % 할당할 수 있는 SU가 존재할때             
                for kk=1:length(remain_user)
                    [remain_detect, idx_remain_detect]=sort(prob_d(:, ambiguous_channel(tt)),'descend');
                    end_idx = length( find( group(:,ambiguous_channel(tt)) ) );
                    group(end_idx+1, ambiguous_channel(tt)) = remain_user(kk);
                    group_Pd(end_idx+1, ambiguous_channel(tt)) = prob_d(remain_user(kk),ambiguous_channel(tt));
                    group_SNR(end_idx+1, ambiguous_channel(tt)) = SU_snr(remain_user(kk),ambiguous_channel(tt));
                    prob_d(remain_user(kk),:) = 0;
                    remain_user(kk) = 0;
                end
            else                                          % 할당할 수 있는 SU가 없을때
%                 group(1, ambiguous_channel) = -10;
%                 group_Pd(1, ambiguous_channel) = -10;
%                 group_SNR(1, ambiguous_channel) = -10;
            end
        end
    else                                                   % 모든 채널에 SU가 할당됬을때
    %         if length(find(remain_user))~=0              % 할당할 수 있는 SU가 존재할때
    %             for kk=1:length(remain_user)
    %                 [remain_detect, idx_remain_detect]=sort(prob_d(remain_user(kk),:),'descend');
    %                 end_idx = length( find( group(:,idx_remain_detect(1)) ) );                        
    %                 group(end_idx+1, idx_remain_detect(1)) = remain_user(kk);
    %                 group_Pd(end_idx+1, idx_remain_detect(1)) = prob_d(remain_user(kk),idx_remain_detect(1));
    %                 group_SNR(end_idx+1, idx_remain_detect(1)) = SU_snr(remain_user(kk),idx_remain_detect(1));
    %                 prob_d(remain_user(kk),:) = 0;
    %                 remain_user(kk) = 0;
    %             end
    %         else                                % 할당할 수 있는 SU가 없을때            
    %         end
    end

end