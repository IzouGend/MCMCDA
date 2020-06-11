function Out = move2_death(W_init,H,T,K,G)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

aliveK=zeros(K,1);
c=1;
for k=1:K
   for g=H-T:G % tiene conto della sliding window
      if tauexist(W_init,g,k) && W_init.track(g).tau(k).frame == 1 % se la track esiste attualmente
         aliveK(c)=k;
         c=c+1;
         break;
      end         
   end
end

if c==1 % tutte le track sono morte
   Out=666;
   return
end
kdead=aliveK(randi(c-1));

for o=H-T:G
   if tauexist(W_init,o,kdead)
   if isfield(W_init.track(o),'tau0') && ~isempty(W_init.track(o).tau0)
      W_init.track(o).tau0=[W_init.track(o).tau0 W_init.track(o).tau(kdead).y]; % si aggiunge ai falsi allarmi
   else
      W_init.track(o).tau0=W_init.track(o).tau(kdead).y;
   end
   W_init.track(o).tau(kdead).y=[]; % si svuota dalle associazioni
   W_init.track(o).tau(kdead).frame=[]; % si svuota l'indice del mumero dell'associazione
   if ~isempty(W_init.track(o).tau(kdead).islast) % se si tratta dell'ultima associazione
      W_init.track(o).tau(kdead).islast = [];
      W_init.track(o).tau(kdead).AAA='mossa2'; %%%%%%%%%%%%
      break
   end
   end
end
% non si fa W_init.tracks = K-1; perche' K e' il numero di tutte le track esistite od esistenti
Out=W_init;

end

