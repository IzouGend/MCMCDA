function W_out = proposal_distribution(W_init)

%global Y % da frame 1 ad H (corrente)
% Y = [Y1 ,..., YH] Y struttura-matrice di tutte le misure fino all'istante corrente H, 
% ogni frame una struttura: Yi=struct('data', matrix_data)
% ogni riga di una normale matrice matrix_data e' una misura [x y z]
% Y(i).data(ai,:) e' l'ai-esima misura 3D dell'instante i


% W_init=struct('track', W_initW_initW_init, 'frame', H-1, 'tracks', K)
% W_initW_initW_init = [W_init1 ,..., W_init{H-1}] matrice delle strutture delle associazioni di ogni instante
% K e' il numero di tutte le track esistite o esistenti
%
% W_init1 associa ad ogni misura un target
%
% W_initt = struct('tau0', false_alarms, 'tau1', 1st_track, ..., 'frame', HW_init)
%
% W_initt.tau0 = [ a1, .., aU] avendo aU falsi allarmi relativi a (..., Y(t).data(ai,:) ,... )
%
% W_initt.taui = struct('y', bi,'frame', n, 'islast', [])  all'n-esimo frame del target i si associa la misura relativa a Y(t).data(bi,:) ,
% islast e' un booleano che dice 1 se e' l'ultima misura del target i, altrimenti e' un campo vuoto
% W_init.track(t).(tau(i)).y e' l'indice della misura bi corrispondente al track i all'istante t
% si presuppone una sola possibile misura per target nel singolo istante (ipotesi di non ubiquita' del target)
% una nuova track puo' non avere un campo associato negli istanti in cui non appare, 
% oppure essere stata cancellata da un instante

% al primo passo di tutto (G=1,H=2) si presuppone che W_init sia gia' inizializzata:
% W_init.track(1).tau(j).y=Y(1).data(j,:);
% W_init.track(1).tau(j).frame=1;
% W_init.track(1).tau(j).islast=1;
% W_init.track(1).tau0=[];
% [Ny ~]=size(Y(1).data);
% W_init.tracks=Ny;

G=W_init.frame; % G = H-1 
H=G+1;
K=W_init.tracks;

global Tmax
% sliding W_initindoW_init, varia come G fino ad un massimo Tmax prima di avere H>Tmax
if H<=Tmax
   T=G;
else
   T=Tmax;
end



%% 
global pd pz d_bar v_bar mprev mcurr xsiprev xsicurr

%%%%%%%%
mprev=mcurr;
xsiprev=xsicurr;

%% move random selection

m=move_selection(K);

mcurr=m;

if m==1 % birth move 
   Out = move1_birth(W_init,H,T,K,d_bar,v_bar,pz); 
   if isnumeric(Out) && Out==666 % no tracks e nessuna nascita: tutti gli oggetti sono usciti dall'inquadratura, oppure si rifiuta la mossa se il percorso creato ha meno di 2 punti
      disp('   m1'); %%%%%%%%%%%%%
      W_out=W_init;
      return
   elseif isnumeric(Out) && Out~=666 % se ritorna il numero di un'altra mossa
      m=Out; % questo fa si' ceh non si possa usare lo switch
      mcurr=m;
   else 
      W_out=Out;
   end
end


if m==2 % death move 
   Out = move2_death(W_init,H,T,K,G);
   if isnumeric(Out) && Out==666 % tutte le track sono morte
            disp('   m2'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end
end


if m==3 % split move
   Out = move3_split(W_init,H,T,K,G);
   if isnumeric(Out) && Out==666 % 不可能扩展
            disp('   m3'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end
end


if m==4 % merge move
   Out = move4_merge(W_init,H,T,K,G,v_bar);
   if isnumeric(Out) && Out==666 % si rifiuta la mossa se non ci sono coppie di track possibili
            disp('   m4'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end    
end


if m==5 % extension move
   Out = move5_extension(W_init,H,T,K,G,v_bar,d_bar);
   if isnumeric(Out) && Out==666 % tutte le track sono morte
            disp('   m5'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end    
end


if m==6 % reduction move
   Out = move6_reduction(W_init,H,T,K,G);
   if isnumeric(Out) && Out==666 % tutte le track sono morte
            disp('   m6'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end    
end


if m==7 % track update move
   Out = move7_track_update(W_init,H,T,K,G,v_bar,d_bar);
   if isnumeric(Out) && Out==666 % tutte le track sono morte
            disp('   m7'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end    
end


if m==8 % track sW_inititch move
   Out = move8_track_switch(W_init,H,T,K,G,d_bar,v_bar);
   if isnumeric(Out) && Out==666 % si rifiuta la mossa se non ci sono coppie di track possibili
            disp('   m8'); %%%%%%%%%%%%%
            W_out=W_init;
      return
   else 
      W_out=Out;
   end    
end
      
disp('m = '); %%%%%%%%%%%%%
disp(m); %%%%%%%%%%%%%

% function end
end