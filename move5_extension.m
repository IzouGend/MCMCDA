function Out = move5_extension(W_init,H,T,K,G,v_bar,d_bar)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

global pz

aliveK=zeros(K,2);
c=1;
for k=1:K
   for g=H-T:G % 考虑到滑动窗口
      if tauexist(W_init,g,k) && ~isempty(W_init.track(g).tau(k).islast) % 如果航迹存在并且处于最后时刻, 并且航迹长度不等于1
         aliveK(c,:)=[k g];
         c=c+1; 
         break;
      end         
   end
end

if c==1 % 所有航迹都已经消亡
   Out=666;
   return
end
a=randi(c-1);
k2extend=aliveK(a,1);
tfk2extend=aliveK(a,2);
N2ext=W_init.track(tfk2extend).tau(k2extend).frame;
% 以新生变换来实现
Out = move1_birth(W_init,H,T,K,d_bar,v_bar,pz,k2extend,tfk2extend,N2ext);

end

