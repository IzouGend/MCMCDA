function Out = move4_merge(W_init,H,T,K,G,v_bar)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

global Y % da frame 1 ad H (corrente)

neartaus=zeros(K,4); % sarebbero K! possibili coppie, ma per troppi marker e' oneroso, si pongono K possibilita'
tf=zeros(K); % istanti finali
c=1; % in caso il counter aggiunge righe alla matrice
for k1=1:K
   for g=H-T:G % tiene conto della sliding window
      if tauexist(W_init,g,k1) && ~isempty(W_init.track(g).tau(k1).islast) % per ogni istante finale tauk1(tf)
         tf(k1)=g;
         for k2=1:K
            if k2~=k1 && g+1 <= G % evita sia G<2 sia di sforare nel futuro
               for h=g+1:G % cercando negli instanti in avanti
                  if tauexist(W_init,h,k2) &&  W_init.track(h).tau(k2).frame==1 % se si trova il primo frame di qualche track
                     if pdist([ Y(g).data( W_init.track(g).tau(k1).y ,:) ; Y(h).data( W_init.track(h).tau(k2).y ,:) ]) <= (h-g)*v_bar
                        neartaus(c,:)=[k1 g k2 h]; 
                        c=c+1;
                     end
                  end
               end
            end
         end
      end
   end
end

if c==1
   Out=666;
   return % si rifiuta la mossa se non ci sono coppie di track possibili
end


%neartaus(Msp,:)=[k1 g k2 h]; 
q=neartaus(randi(c-1),:);

K1=q(1);
tf1=q(2);

K2=q(3);
ti2=q(4);
tf2=tf(K2);


W_init.track(tf1).tau(K1).islast=[];
n = W_init.track(tf1).tau(K1).frame;
b=1;

for o=ti2:tf2
   if tauexist(W_init,o,K2)
      W_init.track(o).tau(K1).y = W_init.track(o).tau(K2).y; % la track K2 diventa la track K1
      W_init.track(o).tau(K1).frame = n+b;
      W_init.track(o).tau(K2).y = []; % si svuota K2
      W_init.track(o).tau(K2).frame = [];
      b=b+1;
   end
end      
W_init.track(tf2).tau(K1).islast=1;
W_init.track(tf2).tau(K1).AAA='mossa4'; %%%%%%%%%%%%

% non si fa W_init.tracks = K-1; perche' K e' il numero di tutte le track esistite od esistenti 

Out=W_init;

end

