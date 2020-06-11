function tauexistance = tauexist(W,t,k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global Hfinal

tauexistance = t<=Hfinal && ~isempty(W.track(t).tau);
if tauexistance
   tauexistance = tauexistance && k<=length(W.track(t).tau);
   if tauexistance
      tauexistance = tauexistance && ~isempty(W.track(t).tau(k));
      if tauexistance
         tauexistance = tauexistance && isfield(W.track(t).tau(k),'y') && ~isempty(W.track(t).tau(k).y);
      end
   end
end


end

