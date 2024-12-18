% input prompt, must put .wav in the string to work
noisySpeechFile = input('Please enter the name of the noisy speech file (ex. noisySpeechFile.wav):', 's');
% catch for file because its input
if ~isfile(noisySpeechFile)
    error('File "%s" does not exist. Please make sure the file is in the current directory.', noisySpeechFile);
end
[noisySpeech, fs] = audioread(noisySpeechFile);
%handle dual-band signal
if size(noisySpeech, 2) > 1
    % Average the two channels into one, =data loss so its gonna sound awful
    noisySpeech = mean(noisySpeech, 2); 
end
%insert handle for multi-band here later if i finish other
% Parameters initialization
% Frame length needed for STFT
frameLength = 256;   
 %overlap
overlap = frameLength / 2; 
% Number of FFT point
numFFT = 512;          

% Manual STFT of the noisy signal
% Create Hamming window
window = hamming(frameLength);

% Number of frames
numFrames = floor((length(noisySpeech) - overlap) / (frameLength - overlap));

% Initialize STFT matrix
stftMatrix = zeros(numFFT, numFrames);

for k = 1:numFrames
    % Frame start and end 
    startIndex = (k-1) * (frameLength - overlap) + 1;
    endIndex = startIndex + frameLength - 1;
    % Extract frames 
    frame = noisySpeech(startIndex:endIndex);
    
    % Apply windowing function, smooth audio of frame before FFT
    windowedFrame = frame .* window;
    
    % FFT
    stftMatrix(:, k) = fft(windowedFrame, numFFT);
end

% magnitude of noisy signal
magnitudeSquared = abs(stftMatrix).^2;

% Noise estimation: Average over silent frames under using first frames
noiseFrames = 10;
noisePowerSpectrum = mean(magnitudeSquared(:, 1:noiseFrames), 2);

% Spectral subtraction with SSF
%and now over-subtraction
subtractionFactor = 1.0;
gainFunction = max(0, 1 - subtractionFactor * (noisePowerSpectrum ./ magnitudeSquared));
enhancedMagnitude = sqrt(gainFunction) .* abs(stftMatrix);

% Reconstruct signal with phase from noisy signal
enhancedSTFT = enhancedMagnitude .* exp(1j * angle(stftMatrix));

% Manual ISTFT to get the time-domain enhanced signal
finalSignal = zeros(length(noisySpeech), 1);
%for-loop for each frame but for inverse
for k = 1:numFrames
    % inverse FFT
    frame = ifft(enhancedSTFT(:, k), numFFT);
    startIndex = (k-1) * (frameLength - overlap) + 1;
    endIndex = startIndex + frameLength - 1;

    % Add the inverse FFT result to the final edited signal with overlap &add method
    finalSignal(startIndex:endIndex) = finalSignal(startIndex:endIndex) + real(frame(1:frameLength));
end

enhancedSpeech = finalSignal;

% Normalize
enhancedSpeech = enhancedSpeech / max(abs(enhancedSpeech));

% Save the final edited speech - user can name file but not directiry :(
outputFile = input('Please enter the name that you want the clean file to be (ex. cleanFile.wav):', 's');
audiowrite(outputFile, enhancedSpeech, fs);

% test success of audiowrite
fprintf('Enhanced speech has been saved to "%s".\n', outputFile);

% initial signal plot
figure;
subplot(3, 1, 1);
plot(noisySpeech);
title('Noisy Speech Signal');
xlabel('Time (samples)');
ylabel('Amplitude');

subplot(3, 1, 2);
%spectogram
%had errors with multi so this is supposed to catch if another error arises
try
    spectrogram(noisySpeech, hamming(frameLength), overlap, numFFT, fs, 'yaxis');
    title('Spectrogram of Noisy Speech');
    xlabel('Time (samples)');
    ylabel('Frequency (kHz)');
catch ME
    warning('Spectrogram failed:', '%s', ME.message);
    title('Spectrogram Error');
end
%result plot
subplot(3, 1, 3);
plot(enhancedSpeech);
title('Enhanced Speech Signal');
xlabel('Time (samples)');
ylabel('Amplitude');