function Out = move3_split(W_init,H,T,K,G)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% si scelgono i track con piu' di 4 frame %%%%%%%%%%  da rifare usando campo frame di taui
longtaus=zeros(K,G);
for k=1:K
   for g=H-T:G % tiene conto della sliding window
      if tauexist(W_init,g,k) %%%%%%%%%%%%%%
         longtaus(k,g) = 1;
      end
   end
end

Ltau=find(sum(longtaus,2) >= 4); % riporta i track che soddisfano la condizione di lunghezza
if isempty(Ltau)
   Out=666;
   return % si rifiuta la mossa se non ci sono track presenti in almeno 4 frame
end

s=Ltau(randi(length(Ltau))); % sceglie un track a caso tra questi, tau_s
Ts=find(longtaus(s,:)==1); % tutti gli instanti validi di tau_s
line=length(Ts); % numero di istanti in cui si presenta tau_s
r=randi(line); % tr=Ts(r); % sceglie l'istante mediano a caso tra quelli validi del track taus
while r==1 || r==line || r==line-1  % tr==Ts(1) || tr==Ts(line) || tr==Ts(line-1) || tr==Ts(line-2) % l'istante mediano deve essere tra i frame [2,...,abs(taui)-2], altrimenti si riestrae
   r=randi(line); % tr=Ts(r);
end

% la track s rimane da 1 ad r
W_init.track(Ts(r)).tau(s).islast=1;

for o=r+1:line 
   W_init.track(Ts(o)).tau(K+1).y = W_init.track(Ts(o)).tau(s).y;  % track2 = dal mediano alla fine
   W_init.track(Ts(o)).tau(K+1).frame = o-r; % si dice a che i-esima osservazione di tauK1 corrisponda
   W_init.track(Ts(o)).tau(s).y=[]; % si svuota dalle associazioni
   W_init.track(Ts(o)).tau(s).frame=[]; 
end      
W_init.track(Ts(line)).tau(K+1).islast=1;
W_init.track(Ts(line)).tau(s).islast=[];
W_init.track(Ts(line)).tau(K+1).AAA='mossa3'; %%%%%%%%%%%%
W_init.tracks=K+1; % sono ora K+1 track esistite od esistenti in tutto

Out=W_init;

end

