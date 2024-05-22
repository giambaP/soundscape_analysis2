% % prova filtraggio
% audioName =  strcat('./database/YAT2Audible/20200301_220000.WAV');
% iBlockLength = 4096 * 8;
% iHopLength = 2048 * 8;
% 
% [y, f_s] = audioread(audioName);
% [X, f, t] = ComputeSpectrogram(y, f_s, [], iBlockLength, iHopLength);
% max(f)
% min(f)
% % range f < 8000
% a = find(f<8000);
% 
% % per un range
% a = find(f>1000 & f<8000);
% 
% 
% filteredX = zeros(size(X));
% filteredX(a,:) = X(a,:);
% 
