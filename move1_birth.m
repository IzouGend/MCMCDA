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


%%%%% 序列的第一个点
if nargin > 7 % 拓展变换 
   t1 = H - tfk2ext;
   d1 = randi(d_bar);
else
   t1 = randi(T-1); % 随机选择新航迹起始时间和时间间隔
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
            if tauexist(W_init,H-t1,k) && J == W_init.track(H-t1).tau(k).y % 如果第H-t1时刻的第J个测量与某航迹有关联 %%%%%%%%%%%%%%%%%%%%
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


% 是否为空
if nargin > 7 % 扩展变换
   if void
      Out=666; % 扩展不可用
      return
   else
      It1=ones((H-t1),1); % 标志位，标志从t1开始直到当前时刻止丢失(未被加到轨迹中)的时刻

      tq = zeros((H-t1+1),1);
      J_q = zeros((H-t1+1),1);
      tq(1) = t1;
      tqcounter = 1;
      track_amolst_void = 1; % 轨迹只有一个元素
      
      J_q(tqcounter) = W_init.track(H-t1).tau(k2ext).y;
   end
   
else
   if void
      m=move_selection(K,'nobirth');
      Out=m;
      return
   else
      It1=ones((H-t1),1); % 标志位，标志从t1开始直到当前时刻止丢失(未被加到轨迹中)的时刻

      tq = zeros((H-t1+1),1);
      J_q = zeros((H-t1+1),1);
      tq(1) = t1;
      tqcounter = 1;
      track_amolst_void = 1; % 轨迹只有一个元素

	  a=find(tauK1set1==1);
      J_q(tqcounter) = a(randi(length(a))); % 选择新生轨迹的大小，与Y(H-t1).data(J_first,:)对应
   end
end


breaktool=1;
while ~isempty(It1) % 只要有tqcounter的空余位置直到当前时刻或者直到循环数量达到终点
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
      tqx = tq(tqcounter); % 前一时刻
      J_qx = J_q(tqcounter);

      if H-tqx+dq > H % 超过当前时刻 
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

      % 选择航迹连续时刻的大小，与Y(H-t1).data(J_q,:)对应
      void=1;

      tauK1setq=zeros(nt(H-tqx+dq),1);
      for J=1:nt(H-tqx+dq)
         used=0;
         for k=1:K
            if tauexist(W_init,H-tqx+dq,k) 
               if J == W_init.track(H-tqx+dq).tau(k).y % 第H-tq+dq时刻的第J个量测与已有航迹关联 %%%%%%%%%%%%%%%%%%%%%%% 
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
      	 J_q(tqcounter) = a(randi(length(a))); % 选择测量作为轨迹在tqx+dq时的下一个量测
         
      end
   end
end




if track_amolst_void
   Out=666;
   return % 如果建立的路径点数小于2则该变动被拒绝
end



% 提出划分
% 未能确定变动被接受之前，该项操作不能进行

if nargin > 7 % 扩展变动 
   K1=k2ext;
else
   K1=K+1;
   W_init.tracks = K1; % 新的轨迹产生
end

if nargin > 7
   
   for o=1:tqcounter-1 
       % 新的航迹从从时刻H-t1开始创建, 即使以后消失，其tau(K1)域在后续的时刻中也会永远保持
       W_init.track(H-tq(o)).tau(K1).y=J_q(o);
       W_init.track(H-tq(o)).tau(K1).frame=N2ext+o-1; % tauK1的第i个响应设为对应的
       if isfield(W_init.track(H-tq(o)),'tau0') && ~isempty(W_init.track(H-tq(o)).tau0)
          W_init.track(H-tq(o)).tau0(W_init.track(H-tq(o)).tau0==J_q(o))=NaN; % 如果出现从虚警中移除，换为NaN
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

