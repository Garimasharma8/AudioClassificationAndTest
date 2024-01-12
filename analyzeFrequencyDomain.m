% function to analyze time domain signals
function freqAnalysisResults = analyzeFrequencyDomain(audioSignal, fs)
    
    if iscell(audioSignal)
        audioSignal = cell2mat(audioSignal);
    else
        audioSignal = audioSignal;
    end

    % Convert audio signal to mono channel
    if size(audioSignal,1) ~=1
        audioSignal = audioSignal(1,:);
    end



    out = checkSignalIntegrity(audioSignal,fs);
    
    % Perform analysis operations
    % Compute the one-sided FFT
    if (out==0)
       Y = fft(audioSignal);
        N = length(Y);
        Y_one_sided = Y(1:N/2+1);
        peakFrequency = max(abs(Y_one_sided));
        pitchCalculated = pitch(audioSignal',fs);
        sortedPitch = sort(pitchCalculated);
        fundamentalFrequency = sortedPitch(1,1);

    % Package the results into a structure
    freqAnalysisResults = struct(...
        'signalFFT', Y_one_sided, ...
        'peakFrequency', peakFrequency,...
        'pitchCalculated',pitchCalculated,...
        'fundamentalFrequency', fundamentalFrequency);
    else
        disp('The frequency analysis of this signal is not possible')
    end
end