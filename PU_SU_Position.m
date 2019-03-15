%==========================================================================
% 3. Primary users and Secondary users Positioning
%   - 
% 1. 수정날짜: 2018-0726
% 2. 수정내용: 1)
%
%==========================================================================

function [PU, SU] = PU_SU_Position(Num_channel, Num_user, rc)
x1 = 1;
y1 = 1;
    for t=1:Num_user %loop until doing 1000 points inside the circle
    %% Secondary User Position
        [x_s y_s]=cirrdnPJ(x1,y1,rc);
%         plot(x_s,y_s,'rx','LineWidth',2, 'MarkerSize',8);
%         markertext = ['SU',num2str(t)];
%         text(x_s,y_s,markertext,'VerticalAlignment','top');
        SU(1,t) = x_s;
        SU(2,t) = y_s;
        % 변수 SU는 secondary user의 위치정보를 저장
    %% Primary User Position
        if t > Num_user-Num_channel
            [x_p y_p]=cirrdnPJ(x1,y1,rc);
%             if channel_state(t-(Num_user-Num_channel)) == 0
%                 plot(x_p,y_p,'ko','LineWidth',2, 'MarkerSize',8,'MarkerFaceColor','w');
%             else
%                 plot(x_p,y_p,'ko','LineWidth',2, 'MarkerSize',8,'MarkerFaceColor',[0 1 0]);
%             end        
%             markertext = ['PU',num2str(t-Num_user+Num_channel)];
%             text(x_p,y_p,markertext,'VerticalAlignment','top');
            PU(1,t-Num_user+Num_channel) = x_p;
            PU(2,t-Num_user+Num_channel) = y_p;
            % 변수 PU는 primary user의 위치정보를 저장
        end       
    end

end