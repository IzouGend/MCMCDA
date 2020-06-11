function [ prob ] = PW_Y( W )
% PW_Y( W ): P(w|Y)
% �������������ʷ����Y���������������Ĺ���w�ĸ���
% ����Y�͸���Pz,Pd,L_Birth��L_FalseΪ�ű��ڿɼ���ȫ�ֱ���

global C Y pz pd L_Birth L_False Tmax randomw


% W=struct('track', A, 'frame', H-1, 'tracks', K)
% A = [w1 ,..., w{H-1}] matrice delle strutture delle associazioni di ogni instante
% K e' il numero di tutte le track esistite o esistenti
%
% w1 associa ad ogni misura un target
%
% wt = struct('tau0', false_alarms, 'tau1', 1st_track, ..., 'frame', Hw)
%
% wt.tau0 = [ a1, .., aU] avendo aU falsi allarmi relativi a (..., Y(t).data(ai,:) ,... )
%
% wt.taui = struct('y', bi,'frame', n, 'islast', [])  all'n-esimo frame del target i si associa la misura relativa a Y(t).data(bi,:) ,
% islast e' un booleano che dice 1 se e' l'ultima misura del target i, altrimenti e' un campo vuoto
% W.track(t).(tau(i)).y e' l'indice della misura bi corrispondente al track i all'istante t
% si presuppone una sola possibile misura per target nel singolo istante (ipotesi di non ubiquita' del target)
% una nuova track puo' non avere un campo associato negli istanti in cui non appare, 
% oppure essere stata cancellata da un instante

%  W.track(t).(tau(i)).y  >>>>>  Y(t).data(W.track(t).(tau(i)).y,:)=[x y z]
product_tracks = 1;
%% 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%  Part I %%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ntracks = W.tracks;
% exact number of total instant H
G=W.frame; % G = H-1 
H=G+1;
        
% ����W_initindoW_initʹ������G���������ֵTmax
if H<=Tmax
   T=G;
else
   T=Tmax;
end
    
for i = 1:Ntracks
   %% ��ʼ��
   % i = track index
   start_i=0;
   end_i=0;

   measure = zeros(H,3);  % Ԥ���ٵĲ�������
   Tau = zeros(G,1);      % Ԥ���ٵ�Tau��������



   %% �ӽṹ��W����ȡ��i���켣������
   for cont=H-T:G          

      if ~tauexist(W,cont,i) % emptyW( W, cont, i )            
         Tau(cont) = NaN;
      else
         if start_i == 0
            % ��ȡ�켣i����ʼ����
            % ��ʼ����Tau(cont)~=NaN
            start_i = cont;
         end

         Tau(cont) = W.track(cont).tau(i).y; 
         end_i=cont;   % ��ȡ�켣i����ֹ����:
         % ��󱣳�Tau(cont)~=NaN
      end

   end

   % �켣����
   len_taui = end_i -start_i + 1;

   %% ��ȡ�͵�i���켣��ص����в���
   for cont=H-T:G   % H��ǰʱ��
      if ~isempty(randomw)
         if isnan(Tau(cont))  || (~isnan(Tau(cont)) && length(Y(cont).data) > Tau(cont))
            y=[NaN NaN NaN];  % δ��⵽
         else
            y = Y(cont).data(Tau(cont) , :);
         end

         measure(cont,:) = y;
      else
         if isnan(Tau(cont))
            y=[NaN NaN NaN];  % Marker not detected
         else
            y = Y(cont).data(Tau(cont) , :);
         end

         measure(cont,:) = y;
      end


   end

   %% �ÿ������˲�����ÿ��ʱ�̵�Ԥ��ֵ
   [ xhat, P ] = kalman( measure, start_i, end_i );
   yhat = C * xhat;

   %% Product N1
   product_instants = 1;
   for cont=2:len_taui % 
      % ��һ�ε�����cont=2��Ϊcont=1ʱ�µĹ켣��ʼ���µı�ǩ and the
      % ��cont=1ʱ��Ŀ�������º����ĸ���Ϊ1

      % ��˹���������
      if ~isnan(measure(cont,1)')
         B = C * P(:,:,cont) * C';

         x = measure(cont,:)';        
         %             factor = 1/(sqrt((2*pi)^3 * det(B))) * exp(-0.5* (x-yhat(:,cont))'...
         %                 *  (eye(3)/B) * (x-yhat(:,cont))   );

         %factor=mvncdf(x+0.1,yhat(:,cont),B)-mvncdf(x-0.1,yhat(:,cont),B);
         %factor=mvncdf(x,yhat(:,cont),B);
         factor=mvnpdf(x,yhat(:,cont),B);


         product_instants = product_instants * factor; 
      end
   end

   product_tracks = product_tracks * product_instants;


end
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  Part II %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           

Et =0;
product_env =1;
for cont=H-T+1:H

   [Nt,~] = size(Y(cont).data);  %  # of observations

   Zt = 0; %  # of targets terminated
   At = 0; %  # of new targets 
   Dt = 0; %  # of detected targets
   Ct = 0;

   for i=1:Ntracks
      if tauexist(W,cont,i)
         Dt=Dt+1; % one more marker detected
      end  
% 
%       if cont~=1
%          if ~tauexist(W,cont,i) && tauexist(W,cont-1,i) %  tauexist(W,t,k)
%             Zt=Zt+1; % one more track is terminated (death)
%          end
% 
%          if tauexist(W,cont,i) && ~tauexist(W,cont-1,i)
%             At=At+1; % one more track is started (birth)
%          end
%       else 
%          At=Dt;
%       end
      if tauexist(W,cont,i) && W.track(cont).tau(i).frame==1
         At=At+1;
      end

      if tauexist(W,cont,i) && ~isempty(W.track(cont).tau(i).islast)
         Zt=Zt+1;
      end
      
      if ~tauexist(W,cont,i) && tauexist(W,cont-1,i) && isempty(W.track(cont-1).tau(i).islast)
         Ct=Ct+1;
      end

   end   

   if cont==1
      L_B=1;
   else
      L_B=L_Birth;
   end
   
   Ft = length(find(~isnan(W.track(cont).tau0)));%Nt - Dt;               %  # of false alarms
   %Ct = Et - Zt;               %  # of previous targets not termited 
   
   if Et - Zt + At - Dt > 0 %Et - Dt >0
      Ut = Et - Zt + At - Dt;     %  # of undetected target  
   else
      Ut=0;
   end
   
   
   product_env= product_env * pz^Zt * (1-pz)^Ct * pd^Dt * (1-pd)^Ut * L_B^At * L_False^Ft;
   %display('======================')
   %disp(pz^Zt); disp((1-pz)^Ct ); disp(pd^Dt); disp((1-pd)^Ut); disp(L_Birth^At); disp(L_False^Ft);
   
   %t = Et + At - Zt;  % # of Marker present on scene 
   % Et referres to time t-1
   Et = Nt-Ft;
end

    prob = product_env * product_tracks;
    
end
   

