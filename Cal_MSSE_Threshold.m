function [min_error_th, SNRdB] = Cal_MSSE_Threshold(Ns, P_avg_N0, M_SNR, m_SNR)
% gamma(k,:) = 10.^(SU_snr(k,:)/10);
% alpha(k,:) = 2.*( (var(n0(:,:,k)).*10^3).^2 ).*gamma(k,:)./Ns;
% beta(k,:) = -gamma(k,:).*alpha(k,:).^3./Ns;
% w(k,:) = (-alpha(k,:).^4 .* gamma(k,:).^2)./Ns - ((alpha(k,:).^4)./(Ns^2)).*(2.*gamma(k,:)+1).*log(sqrt(2*gamma(k,:)+1));
% 
% Th1(k,:) = ( -beta(k,:) + sqrt(beta(k,:).^2-alpha(k,:).*w(k,:)) )./alpha(k,:);

max_SNR = M_SNR+1;
min_SNR = m_SNR-1;

sigma_N2 = 10^(P_avg_N0/10)*10^-3;      % [W]
SNR = 10.^(linspace(min_SNR,max_SNR,50)./10);
SNRdB = linspace(min_SNR,max_SNR,50);
N = Ns;

alpha1 = (2*SNR./N)*sigma_N2^2;
beta1 = (-SNR./N).*sigma_N2^3;
w1 = (-SNR.^2 * sigma_N2^4)./N - (sigma_N2^4/(N^2)).*(2*SNR+1).*log(sqrt(2.*SNR+1));
w1 = - SNR.^2.*((sigma_N2^4)/N)-(2.*SNR+1).*( 2*sigma_N2^8/(N^2)).*log(sqrt(1+2.*SNR));

min_error_th = (-beta1 + sqrt(beta1.^2 - alpha1.*w1) )./alpha1;
%min_error_th2 = (-beta1 - sqrt(beta1.^2 - alpha1.*w1) )./alpha1;
end