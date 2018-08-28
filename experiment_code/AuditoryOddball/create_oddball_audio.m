a = 1; %amplitude
signal_time = .06;
fs_standard = 500; %sample rate - standard
fs_target = 1000; %sample rate - target

%sampling
fs = 44100;
time_slice = 0:(1/fs):signal_time-(1/fs);

%sinusoidal audio anonymous fxn
f = @(n) a*sin(2*pi*fs_standard*n);
%creat audio files
audiowrite('../Sounds/Sound03 standard.wav',f(time_slice),fs);

%sinusoidal audio anonymous fxn
f = @(n) a*sin(2*pi*fs_target*n);
%creat audio files
audiowrite('../Sounds/Sound04 target.wav',f(time_slice),fs);