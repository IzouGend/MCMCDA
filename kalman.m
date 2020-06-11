function [ xhat, Pout ] = kalman( y, start_i, end_i )
%KALMAN( Y, start_i, end_i ) 
%   Calculates the prediction and variance of the targets states for each
%   istant starting from start_i to end_i
 
global P0 A C Q R
% Andr?? tutto in variabili globali
%     Ts = 1; 
%     sigmaW = 0.02;
%     sigmaV = 0.01;
%     P0 = 100*ones(6,6); %P0 e X0 andranno inizializzate con le precedenti nel caso della sliding window
%     
%     A = [1 Ts 0 0  0 0;
%          0  1 0 0  0 0;
%          0  0 1 Ts 0 0;
%          0  0 0 1  0 0;
%          0  0 0 0  1 Ts;
%          0  0 0 0  0 1];
%     
%     C = [1 0 0 0 0 0;
%          0 0 1 0 0 0;
%          0 0 0 0 1 0];
%     
%     Q = sigmaW * eye(6);
%     R = sigmaV * eye(3);
     
    [n,~]=size(y);
    
    xhat = zeros(6,n);
    P = P0;
    Pout=P0;
    
    for cont = 1:1:(end_i - start_i + 1)
    
        if ~isnan( y(cont ,  1) )
           
            
            % update
            % measure = Y(cont).data(Tau(cont) , :); %estraggo da tutte le misure la misura al tempo T relativo            
            
            K = P * ((C')/(C*P*C' + R));
            xhat(:,cont) = xhat(:,cont) + K * (y(cont,:)' - C*xhat(:,cont));
            P = P - K*C*P;
        end
        
        % prediction
        xhat(:,cont+1) = A*xhat(:,cont);
        P = A*P*A' + Q;
        
        Pout(:,:,cont)=P;
    end
    
    
end


 