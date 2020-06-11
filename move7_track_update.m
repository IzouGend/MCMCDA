function Out = move7_track_update(W_init,H,T,K,G,v_bar,d_bar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global pz
aliveK=zeros(K,2);
c=1;
for k=1:K
   for g=H-T:G % tiene conto della sliding window
      if tauexist(W_init,g,k) && ~isempty(W_init.track(g).tau(k).islast) % se la track esiste attualmente e ci troviamo nell'ultimo instante
         aliveK(c,:)=[k W_init.track(g).tau(k).frame];
         c=c+1;
         break;
      end         
   end
end

if c==1 % tutte le track sono morte
   Out=666;
   return
end
a=randi(c-1);
k2tu=aliveK(a,1);
Nk2tu=aliveK(a,2);

r=randi(Nk2tu);
tfk2tu=[];

% si eliminano le associazioni succssive all r-esimo frame
for g=H-T:G % tiene conto della sliding window
   if tauexist(W_init,g,k2tu) %%%%%%%%%%%%%%%%%%%%%
      if W_init.track(g).tau(k2tu).frame == r
         tfk2tu=g; % da passare poi al birth
      elseif W_init.track(g).tau(k2tu).frame > r
		if isfield(W_init.track(g),'tau0') && ~isempty(W_init.track(g).tau0)
      		W_init.track(g).tau0=[W_init.track(g).tau0 W_init.track(g).tau(k2tu).y]; % si aggiunge ai falsi allarmi
   		else
      		W_init.track(g).tau0=W_init.track(g).tau(k2tu).y;
   		end
         W_init.track(g).tau(k2tu).y=[]; % si svuota dalle associazioni
         W_init.track(g).tau(k2tu).frame=[]; % si svuota l'indice del mumero dell'associazione
         if ~isempty(W_init.track(g).tau(k2tu).islast)
            W_init.track(g).tau(k2tu).islast = [];
            W_init.track(g).tau(k2tu).AAA='mossa7'; %%%%%%%%%%%%
            break;
         end
      end
   end
end




% si usano ora come una birth move
                  
Out = move1_birth(W_init,H,T,K,d_bar,v_bar,pz,k2tu,tfk2tu,r);


end

