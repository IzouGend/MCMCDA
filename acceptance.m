function [ P_acc ] = acceptance( W0, W1 )
%ACCEPTANCE( W0, W1 ) 
%   Calculates the acceptance probability of new feasible association set
%   W0 given the previous accepted feasible solution set W0

global mprev mcurr xsiprev xsicurr % bei pronti

P_acc = min(1, PW_Y(W1)/PW_Y(W0));
%msg=strcat('Prob. acceptance = ',' ',num2str(P_acc));
%disp(msg);
end

