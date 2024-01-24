% function to analyze time domain signals
function freqAnalysisResults = analyzeFrequencyDomain(audioSignal, fs)
    freqAnalysisResults = struct('signalFFT',-1,...
        'peakFrequency',-1,...
        'pitchCalculated',-1,...
        'fundamentalFrequency',-1, 'status',0);

    if iscell(audioSignal)
        audioSignal = cell2mat(audioSignal);
    else
        audioSignal = audioSignal;
    end
    


    freqAnalysisResults.status = checkSignalIntegrity(audioSignal,fs);
    
    % Perform analysis operations
    % Compute the one-sided FFT
    if (freqAnalysisResults.status==0)
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
        disp('Error: The frequency analysis of this signal is not possible')
    end
end