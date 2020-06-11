clear;
clc;
punti_prova;
load('movimento_punti_3D_100frames');
global Ts sigmaW sigmaV P0 A C Q R Y pz pd Tmax nt L_Birth L_False Nmc Hfinal d_bar v_bar randomw
Ts = 1; 
sigmaW = 0.0002;%0.002;
sigmaV = 0.0001;%0.001;
P0 = 1000*eye(6); %P0 e X0 andranno inizializzate con le precedenti nel caso della sliding window

L_Birth=0.000001;
L_False=0.001;

Nmc = 30; % Numero di iterazioni per la costruzione della Proposal

Hfinal=97;

Tmax=10;

randomw=1;

A = [1 Ts 0 0  0 0;
     0  1 0 0  0 0;
     0  0 1 Ts 0 0;
     0  0 0 1  0 0;
     0  0 0 0  1 Ts;
     0  0 0 0  0 1];

C = [1 0 0 0 0 0;
     0 0 1 0 0 0;
     0 0 0 0 1 0];

Q = sigmaW * eye(6);
R = sigmaV * eye(3);

pd = 0.99; % probability detection

pz = 0.1; % probabilita' che scompaia il track



%pd = 0.7; % probability detection
%pdt = 0.99; % prob aver visto il target alemno una volta su s misure


%s = ceil(G); % numero di misure considerato
%pdt = 1-(1-pd)^s; 
d_bar = 2;%= ceil( log(1-pdt)/log(1-pd) );%1

%pz = 1/20; % probabilita' che scompaia il track

v_bar = 0.15;%0.15; % cm/s, max directional speed  of any target, magari da basare con i vincoli di forma/ ricorsivamente



for n=1:100
    
    Y(n).data=points(:,:,n)';
    
    if (rand > 0.90) %perdo una misura con probabilit?? 0.03
        disp('persa!')
        riga = randi(length(points(:,:,n))-2)+1;
        Y(n).data=[Y(n).data(1:riga-1,:); Y(n).data(riga+1:end,:)];
    end
    
    if (rand > 0.90)
        disp('falsa!')
        Y(n).data = [Y(n).data; rand(1, 3)];      
    end
end



[Ny ~]=size(Y(1).data);


% tau=struct();
% for k=1:Ny^2
%    tau=[tau struct()];
% end
% 
% for t=1:Hfinal
%    wt(t)=struct('tau', tau);
% end


wt=struct();
W=struct('track', wt, 'frame', 1, 'tracks', 0);
for t=1:Hfinal+2
   for k=1:Ny^2
      if t==1 && k<=8 
         W.track(1).tau(k).y=k;
         W.track(1).tau(k).frame=1;
         W.track(1).tau(k).islast=1;
         W.track(1).tau0=[];
      else
         W.track(t).tau0=[];
      end
   end
end
W.frame=2;
W.tracks=Ny;


for h=1:Hfinal
   [nt(h),~] = size(Y(h).data);
end

% al primo passo di tutto (G=1,H=2) si presuppone che W sia gia' inizializzata:


W.tracks=Ny;

%testTime = 900;

% % use profiler or not
% useProfiler = true;

% % start profiler
% if useProfiler
% 	profile clear
% 	profile on
% end

% % initialize
% startTime = clock;
% h = waitbar(0, 'Please wait', 'Name', mfilename);

tstart = tic;
for t=1:Hfinal
   W = multiscanMCMCDA(W);
   disp(' ');disp(' ');disp(' ');disp(' ');
   disp('istante =');disp(W.frame);
   disp(' ');disp(' ');disp(' ');disp(' ');
   
%    % set waitbar
%    curTime = etime(clock, startTime);
%    waitbar(curTime/testTime, h);
   
%    % stop after given time
%    if curTime > testTime
%         break
%    end
end
telapsed = toc(tstart);

% close(h);
% 
% if useProfiler
% 	profile off
% 	profile report
% end

plotW(W,Y);


msg=strcat('simulazione_',datestr(now,1),'_',datestr(now,'HH'),'-',datestr(now,'MM'),'-',datestr(now,'SS'));
save(msg);

