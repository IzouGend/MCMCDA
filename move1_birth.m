function Out = move1_birth(W_init,H,T,K,d_bar,v_bar,pz,k2ext,tfk2ext,N2ext)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global Y % da frame 1 ad H (corrente)
global Hfinal

G=H-1; %%%%%%%%%%%%%%%%%%%%%%%%
if T==1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   Out=666; %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   return  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
end   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

global nt % qui da frame 1 ad H


%%%%% ���еĵ�һ����
if nargin > 7 % ��չ�任 
   t1 = H - tfk2ext;
   d1 = randi(d_bar);
else
   t1 = randi(T-1); % ���ѡ���º�����ʼʱ���ʱ����
   d1 = randi(d_bar);
end

while H-t1+d1 > H 
   d1 = randi(d_bar); %  zeta distribution ??????????? controllare quale distribuzione
end

if H-t1+d1 > Hfinal
   Out=666;
   return
end
   

void=1;
if nargin > 7 % extension move 
   for h=1:nt(H-t1+d1)      
      if pdist([ Y(tfk2ext).data( W_init.track(tfk2ext).tau(k2ext).y ,:) ; Y(H-t1+d1).data(h,:) ]) <= d1*v_bar % ~isempty(Ld1_t1(J).td(h).y)
         void=0;
      end
   end
else
   tauK1set1=zeros(nt(H-t1),1);
   for J=1:nt(H-t1)
      for h=1:nt(H-t1+d1)
         used=0;
         for k=1:K
            if tauexist(W_init,H-t1,k) && J == W_init.track(H-t1).tau(k).y % �����H-t1ʱ�̵ĵ�J��������ĳ�����й��� %%%%%%%%%%%%%%%%%%%%
               used=1;
               break;
            end
         end
         if ~used && pdist([ Y(H-t1).data(J,:) ; Y(H-t1+d1).data(h,:) ]) <= d1*v_bar % ~isempty(Ld1_t1(J).td(h).y)
            tauK1set1(J)=1;
            void=0;
         end
      end
   end
end


% �Ƿ�Ϊ��
if nargin > 7 % ��չ�任
   if void
      Out=666; % ��չ������
      return
   else
      It1=ones((H-t1),1); % ��־λ����־��t1��ʼֱ����ǰʱ��ֹ��ʧ(δ���ӵ��켣��)��ʱ��

      tq = zeros((H-t1+1),1);
      J_q = zeros((H-t1+1),1);
      tq(1) = t1;
      tqcounter = 1;
      track_amolst_void = 1; % �켣ֻ��һ��Ԫ��
      
      J_q(tqcounter) = W_init.track(H-t1).tau(k2ext).y;
   end
   
else
   if void
      m=move_selection(K,'nobirth');
      Out=m;
      return
   else
      It1=ones((H-t1),1); % ��־λ����־��t1��ʼֱ����ǰʱ��ֹ��ʧ(δ���ӵ��켣��)��ʱ��

      tq = zeros((H-t1+1),1);
      J_q = zeros((H-t1+1),1);
      tq(1) = t1;
      tqcounter = 1;
      track_amolst_void = 1; % �켣ֻ��һ��Ԫ��

	  a=find(tauK1set1==1);
      J_q(tqcounter) = a(randi(length(a))); % ѡ�������켣�Ĵ�С����Y(H-t1).data(J_first,:)��Ӧ
   end
end


breaktool=1;
while ~isempty(It1) % ֻҪ��tqcounter�Ŀ���λ��ֱ����ǰʱ�̻���ֱ��ѭ�������ﵽ�յ�
   if G > Hfinal
       break
   end
   if (breaktool >= nt(H-tq(tqcounter))*nt(G)*(H-t1))
       break
   end
   if (tqcounter > 2 && rand<=pz)
      break
   else  
      
      dq = randi(d_bar); 
      tqx = tq(tqcounter); % ǰһʱ��
      J_qx = J_q(tqcounter);

      if H-tqx+dq > H % ������ǰʱ�� 
		 for d=1:d_bar
		 	dq=d;
		 	if H-tqx+dq <= H
		 		break
		 	end
		 end
      end

      if  H-tqx+dq > Hfinal || H-tqx+dq > H
         break
      end

      % ѡ�񺽼�����ʱ�̵Ĵ�С����Y(H-t1).data(J_q,:)��Ӧ
      void=1;

      tauK1setq=zeros(nt(H-tqx+dq),1);
      for J=1:nt(H-tqx+dq)
         used=0;
         for k=1:K
            if tauexist(W_init,H-tqx+dq,k) 
               if J == W_init.track(H-tqx+dq).tau(k).y % ��H-tq+dqʱ�̵ĵ�J�����������к������� %%%%%%%%%%%%%%%%%%%%%%% 
               used=1;
               break
               end
            end
         end
         if ~used && pdist([ Y(H-tqx).data(J_qx,:) ; Y(H-tqx+dq).data(J,:) ]) <= dq*v_bar % quelle non assegnate vicine all'istante successivo
            tauK1setq(J)=1;
            void=0;
            track_amolst_void = 0;
         end
      end

      if void
      	 breaktool=breaktool+1;
         continue
      else         
         It1=It1(H-tqx:end); % 
         tqcounter = tqcounter + 1;
         tq(tqcounter)=tqx-dq;
         a=find(tauK1setq==1);
      	 J_q(tqcounter) = a(randi(length(a))); % ѡ�������Ϊ�켣��tqx+dqʱ����һ������
         
      end
   end
end




if track_amolst_void
   Out=666;
   return % ���������·������С��2��ñ䶯���ܾ�
end



% �������
% δ��ȷ���䶯������֮ǰ������������ܽ���

if nargin > 7 % ��չ�䶯 
   K1=k2ext;
else
   K1=K+1;
   W_init.tracks = K1; % �µĹ켣����
end

if nargin > 7
   
   for o=1:tqcounter-1 
       % �µĺ����Ӵ�ʱ��H-t1��ʼ����, ��ʹ�Ժ���ʧ����tau(K1)���ں�����ʱ����Ҳ����Զ����
       W_init.track(H-tq(o)).tau(K1).y=J_q(o);
       W_init.track(H-tq(o)).tau(K1).frame=N2ext+o-1; % tauK1�ĵ�i����Ӧ��Ϊ��Ӧ��
       if isfield(W_init.track(H-tq(o)),'tau0') && ~isempty(W_init.track(H-tq(o)).tau0)
          W_init.track(H-tq(o)).tau0(W_init.track(H-tq(o)).tau0==J_q(o))=NaN; % ������ִ��龯���Ƴ�����ΪNaN
   	   end
       W_init.track(H-tq(o)).tau(K1).islast=[];
       W_init.track(H-tq(o)).tau(K1).AAA='mossa5'; %%%%%%%%%%%%
   end
   
else

   for o=1:tqcounter-1 
       W_init.track(H-tq(o)).tau(K1).y=J_q(o); 
       W_init.track(H-tq(o)).tau(K1).frame=o; 
        if isfield(W_init.track(H-tq(o)),'tau0') && ~isempty(W_init.track(H-tq(o)).tau0)
          W_init.track(H-tq(o)).tau0(W_init.track(H-tq(o)).tau0==J_q(o))=NaN; 
        end       
   	   W_init.track(H-tq(o)).tau(K1).islast=[];
       W_init.track(H-tq(o)).tau(K1).AAA='mossa1'; %%%%%%%%%%%%
   end

end

W_init.track(H-tq(tqcounter-1)).tau(K1).islast=1;


Out=W_init;

end

