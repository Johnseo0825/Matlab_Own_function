%==========================================================================
% 1. Cognivie Radio Network Region and Fusion Center Positioning
%   - 
% 1. ������¥: 2018-0726
% 2. ��������: 1)
%
%==========================================================================
% 1. CR��Ʈ��ũ ���� �� pathloss �Ķ���� ����
%==========================================================================
%axis equal
x1=1;
y1=1;
rc=10000;                    % �������� m(Km)�� ����ũ�μ� => reference distance�� 100m Ȥ�� 1m
[x,y,z] = cylinder(rc,200);
%plot(x(1,:)+x1,y(1,:)+y1,'r');

%==========================================================================
% 2. ���ռ���(Fusion center) �����Ŵ�
%==========================================================================
fc_x =( min(x(1,:))+max(x(1,:))+2*x1 )/2;
fc_y =( min(y(1,:))+max(y(1,:))+2*y1 )/2;
% plot(fc_x, fc_y, 'bs', 'LineWidth',2, 'MarkerSize',10), grid on;
% text(fc_x,fc_y,'FC','VerticalAlignment','top','Color','red','FontSize',12); 

%==========================================================================
% 3. PU�� Base station �����Ŵ�
%==========================================================================
%[BSx_p BSy_p]=cirrdnPJ(x1,y1,rc);
% plot(BSx_p,BSy_p,'Bo','LineWidth',2, 'MarkerSize',8,'MarkerFaceColor','b');
% text(BSx_p,BSy_p,'BS','VerticalAlignment','top');