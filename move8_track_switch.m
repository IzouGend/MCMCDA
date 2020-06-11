function Out = move8_track_switch(W_init,H,T,K,G,d_bar,v_bar)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global Y % da frame 1 ad H (corrente)


neartaupairs=zeros(K*K,4); % sarebbero K!*(G+1)! possibili coppie, ma per troppi marker e' oneroso, si pongono K*K possibilita'
c=1; % in caso il counter aggiunge righe alla matrice

% ordine temporale: [ t_{p} <--> t_{q} ]  >-->  [ t_{p+1} <--> t_{q+1} ]
for k1=1:K
   for g=H-T:G % t_{p} , tiene conto della sliding window
      if tauexist(W_init,g,k1) && isempty(W_init.track(g).tau(k1).islast) % se e' un istante di k1, non l'ultimo
         n1=W_init.track(g).tau(k1).frame;
         for g1=g+1:G % t_{p+1}
            if tauexist(W_init,g1,k1) && W_init.track(g1).tau(k1).frame == n1+1 % si cerca l'istante successivo
               for k2=1:K
                  for h=g1+1:G % t_{q} , 0 < h-g1
                     if tauexist(W_init,h,k2) && isempty(W_init.track(h).tau(k2).islast) % se e' un istante di k2, non l'ultimo
                        if h-g1 <= d_bar  % 0 < h-g1 <= d_bar
                           if pdist([ Y(h).data( W_init.track(h).tau(k2).y ,:) ; Y(g1).data( W_init.track(g1).tau(k1).y ,:) ]) <= (h-g1)*v_bar  % se tauK1(t_{p+1}) appartiene a L_{t_{p+1}-t_{q}}(tauK2(t_{q})) , l'albero delle associazioni delle distanze 
                              n2=W_init.track(h).tau(k2).frame;
                              if g+1 <= G
                                 for h1=g+1:G % t_{q+1}
                                    if tauexist(W_init,h1,k2) 
                                       if W_init.track(h1).tau(k2).frame == n2+1 % si cerca l'istante successivo
                                          if h1-g <= d_bar
                                             if pdist([ Y(h1).data( W_init.track(h1).tau(k2).y ,:) ; Y(g).data( W_init.track(g).tau(k1).y ,:) ]) <= (h1-g)*v_bar  % se tauK2(t_{q+1}) appartiene a L_{t_{q+1}-t_{p}}(tauK1(t_{p})) , l'albero delle associazioni delle distanze 
                                                neartaupairs(c,:)=[k1 g1 k2 h1]; % a noi servono gli istanti successivi
                                                c=c+1;
                                             end
                                          end
                                       end
                                    end
                                 end
                              end
                           end
                        end
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


q=neartaupairs(randi(c-1),:);

K1=q(1);
tp1=q(2);
n1=W_init.track(tp1).tau(K1).frame;
b1=1; % indice per il numero frame successivo da n1

K2=q(3);
tq1=q(4);
n2=W_init.track(tq1).tau(K2).frame;
b2=1; % indice per il numero frame successivo da n2

last1OR2=0;
for o=min(tp1,tq1):G
   if tauexist(W_init,o,K1) && tauexist(W_init,o,K2)
      SWAP=W_init.track(o).tau(K2).y;
      W_init.track(o).tau(K2).y = W_init.track(o).tau(K1).y; % la track K1 diventa la track K2
      W_init.track(o).tau(K2).frame = n2+b2;
      b2=b2+1;
      W_init.track(o).tau(K1).y = SWAP; % la track K2 diventa la track K1
      W_init.track(o).tau(K2).frame = n1+b1;
      b1=b1+1;
   elseif tauexist(W_init,o,K1)
      W_init.track(o).tau(K2).y = W_init.track(o).tau(K1).y; % la track K1 diventa la track K2
      W_init.track(o).tau(K2).frame = n2+b2;
      b2=b2+1;   
      W_init.track(o).tau(K1).y = []; % si svuota K1
      W_init.track(o).tau(K1).frame = [];
   elseif tauexist(W_init,o,K2)
      W_init.track(o).tau(K1).y = W_init.track(o).tau(K2).y; % la track K2 diventa la track K1
      W_init.track(o).tau(K1).frame = n1+b1;
      b1=b1+1;   
      W_init.track(o).tau(K2).y = []; % si svuota K1
      W_init.track(o).tau(K2).frame = [];      
   end
   
   if tauexist(W_init,o,K1) && ~isempty(W_init.track(o).tau(K1).islast)
      W_init.track(o).tau(K1).islast=[];
      W_init.track(o).tau(K2).islast=1;
      W_init.track(o).tau(K1).AAA='mossa8'; %%%%%%%%%%%%
      if ~last1OR2
         last1OR2=1;
      else
         break % si e' arrivati all'istante finale dell'ultima track tra le due che non era giunta al termine
      end
   end
   if tauexist(W_init,o,K2) && ~isempty(W_init.track(o).tau(K2).islast)
      W_init.track(o).tau(K2).islast=[];
      W_init.track(o).tau(K1).islast=1;
      W_init.track(o).tau(K2).AAA='mossa8'; %%%%%%%%%%%%
      if ~last1OR2
         last1OR2=1;
      else
         break % si e' arrivati all'istante finale dell'ultima track tra le due che non era giunta al termine
      end
   end
end      


Out=W_init;

end

