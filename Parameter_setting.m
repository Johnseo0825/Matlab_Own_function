%==========================================================================
% 2. Parameter Setting
%   - Number of samples, Bandwidth, Carrier frequency, Pathloss parameters
% 1. 수정날짜: 2018-0726
% 2. 수정내용: 1)
%
%==========================================================================
Ns = 20;                                  % 센싱 샘플 수 
BW = 6;                                   % Bandwidth = 6[MHz];
f_carrier = 900*10^6;                     % fc = 900MHz
lambda_c  = 3*10^8 / f_carrier;           % 파장길이
P_avg_N0  = -100;                         % 노이즈 파워 [dBm]
target_Pe = 0.15;
target_Pd = 0.972;