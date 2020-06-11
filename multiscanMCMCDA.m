function W_hat = multiscanMCMCDA(W_prev)
% multiscanMCMCDA multi scan MCMCDA  tracking algorithm
%   centralized version


global Y % da frame 1 ad H (corrente)
% Y = [Y1 ,..., YH] Y struttura-matrice di tutte le misure fino all'istante corrente H, 
% ogni frame una struttura: Yi=struct('data', matrix_data)
% ogni riga di una normale matrice matrix_data e' una misura [x y z]
% Y(i).data(ai,:) e' l'ai-esima misura 3D dell'instante i

global nt % qui da frame 1 ad H
 
%[nt(H),~] = size(Y(H).data); % da frame 1 ad H, cresce ad ogni passo ma c'e' quadratino verde lo stesso..


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

% al primo passo di tutto (W.frame = 1; H=2) si presuppone che W sia gia' inizializzata:
% W.track(1).(tau(j)).y=Y(1).data(j,:);
% W.track(1).(tau(j)).frame=1;
% W.track(1).(tau(j)).islast=1;
% W.track(1).tau0=[];
% [Ny ~]=size(Y(1).data);
% W.tracks=Ny;



% global Nmc
% Nmc = Nmc + nt(H); % aggiornamento numero campioni, piu' veloce che fare sum(sum(Y)) ogni volta

global Nmc

%W_hat=struct(); %%%%%%%%%%


W_init = W_prev;
W_W = W_init;
W_hat = W_init;
for n=1:Nmc
% 	propose w_prop based on w_prev
	W_primo = proposal_distribution(W_hat);
	U=rand;
    % 是否有问题？X.W.Cui,2020-3-26.
    pww = PW_Y(W_W); 
    pwp = PW_Y(W_primo);
%     pwh = PW_Y(W_hat);
%     acc=acceptancePw(pww, pwh);
    acc=acceptancePw(pww, pwp);
   
	if U<acc  % se sotto la proprieta' di accettazione 
        W_W = W_primo;
        pww = PW_Y(W_W);
        disp('ACCEPT');
   end    
   

    msg=strcat('U = ',num2str(U),' acc = ',' ',num2str(acc),'; pww = ',' ',num2str(pww), ', pwp = ',' ',num2str(pwp));
    disp(msg);
    pwh = PW_Y(W_hat);
	if pww>pwh % se w_w piu' probabile di w_hat
        W_hat = W_W;
        disp('                                                        PASSPROB');
	end 
	    
    msg=strcat('istante = ',' ',num2str(W_prev.frame),', iterazione = ',' ',num2str(n));
    disp(msg);
    disp(' ');
end




W_hat.frame = W_hat.frame + 1; % questo perche' si sta proponendo la W fino alle Y correnti (istante H)

% function end
end
