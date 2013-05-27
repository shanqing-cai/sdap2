function test_sdap2(varargin)
dataFN = 'G:\DATA\RHYTHM-FMRI\PILOT_ANS_M01\run1\rep1\trial-1-1.mat';

%%
load(dataFN); % gives data

fs = data.params.sr;

sigIn = data.signalIn;

sigIn = resample(sigIn, 48000, fs);     
sigInCell = makecell(sigIn, 96);    

TransShiftMex(6);   % Reset;

MexIO('init', data.params);

%% Setting ost and pcf
ost_fn = '../pert/ost';
pcf_fn = '../pert/pitch_up.pcf';

check_file(ost_fn);
check_file(pcf_fn);

TransShiftMex(8, ost_fn, 1);
TransShiftMex(9, pcf_fn, 1);

TransShiftMex(3, 'bbypassfmt', 1, 1);
TransShiftMex(3, 'bpitchshift', 1, 1);

%%
for n = 1 : length(sigInCell)
    TransShiftMex(5, sigInCell{n});
end

data1 = MexIO('getData');

%%
figure('Position', [50, 100, 1200, 600], 'Name', mfilename);
subplot('Position', [0.1, 0.1, 0.85, 0.85]);
show_spectrogram(data1.signalIn, data1.params.sr, 'noFig');
frameDur = data1.params.frameLen / data1.params.sr;
tAxis = 0 : frameDur : frameDur * (size(data1.rms, 1) - 1);
plot(tAxis, data1.ost_stat * 500, 'w-');

figure('Position', [50, 100, 1200, 600], 'Name', mfilename);
subplot('Position', [0.1, 0.1, 0.85, 0.85]);
show_spectrogram(data1.signalOut, data1.params.sr, 'noFig');

if ~isempty(fsic(varargin, '--play'))
    soundsc(data1.signalIn, data1.params.sr);
    pause(0.1);
    soundsc(data1.signalOut, data1.params.sr);
end

return