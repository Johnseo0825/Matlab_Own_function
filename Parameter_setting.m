%==========================================================================
% 2. Parameter Setting
%   - Number of samples, Bandwidth, Carrier frequency, Pathloss parameters
% 1. ������¥: 2018-0726
% 2. ��������: 1)
%
%==========================================================================
Ns = 20;                                  % ���� ���� �� 
BW = 6;                                   % Bandwidth = 6[MHz];
f_carrier = 900*10^6;                     % fc = 900MHz
lambda_c  = 3*10^8 / f_carrier;           % �������
P_avg_N0  = -100;                         % ������ �Ŀ� [dBm]
target_Pe = 0.15;
target_Pd = 0.972;