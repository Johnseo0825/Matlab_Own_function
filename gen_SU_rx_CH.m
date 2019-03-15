function [h]=gen_SU_rx_CH(Nch, Ns)
    
    for k=1:Nch
        h(:,k) = (gen_SUs_CH(Ns)');
    end
        


end