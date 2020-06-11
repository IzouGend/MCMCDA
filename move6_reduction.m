function Out = move6_reduction(W_init,H,T,K,G)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

aliveK=zeros(K,2);
c=1;
for k=1:K
   for g=H-T:G % ���ǻ�������
      if tauexist(W_init,g,k) && ~isempty(W_init.track(g).tau(k).islast) && W_init.track(g).tau(k).frame~=1 % ����������ڲ��Ҵ������ʱ��, ���Һ������Ȳ�����1
         aliveK(c,:)=[k  W_init.track(g).tau(k).frame];
         c=c+1;
         break;
      end         
   end
end

if c==1 % ���к������Ѿ�����
   Out=666;
   return
end
a=randi(c-1);
k2red=aliveK(a,1);
Nf2kred=aliveK(a,2);

if Nf2kred==2 
   r=2; % r u.a.r. between (2,Nf2kred-1) %%%%%%%%%%%%% IMAX must be greater than or equal to 1
else
   r=randi(Nf2kred-2)+1; % r u.a.r. between (2,Nf2kred-1) %%%%%%%%%%%%% IMAX must be greater than or equal to 1
end



% ��r֮֡��Ĺ���������
for g=H-T:G % ���ǵ���������
   if tauexist(W_init,g,k2red) %%%%%%%%%%%%
      if W_init.track(g).tau(k2red).frame == r
         W_init.track(g).tau(k2red).islast = 1;
      elseif W_init.track(g).tau(k2red).frame > r
         if isfield(W_init.track(g),'tau0') && ~isempty(W_init.track(g).tau0)
      		W_init.track(g).tau0=[W_init.track(g).tau0 W_init.track(g).tau(k2red).y]; % ���뵽�龯��
   		else
      		W_init.track(g).tau0=W_init.track(g).tau(k2red).y;
   		end
         W_init.track(g).tau(k2red).y=[]; % �ӹ��������
         W_init.track(g).tau(k2red).frame=[]; % �������������
         if ~isempty(W_init.track(g).tau(k2red).islast)
            W_init.track(g).tau(k2red).islast = [];
            W_init.track(g).tau(k2red).AAA='mossa6'; %%%%%%%%%%%%
            break
         end
      end
   end         
end




Out=W_init;


end

