% function to analyze time domain signals
function freqAnalysisResults = analyzeFrequencyDomain(audioSignal, fs)
    % Check for empty input
    if isempty(audioSignal)
        error('SignalAnalysis:EmptyInput', 'The input signal cannot be empty.');
    end
    
    % Perform analysis operations
    % Compute the one-sided FFT
    Y = fft(cell2mat(audioSignal));
    N = length(Y);
    Y_one_sided = Y(1:N/2+1);

    peakFrequency = max(abs(Y_one_sided));

    % Extract features from audio data
    

    
    % Package the results into a structure
    freqAnalysisResults = struct(...
        'signalFFT', Y_one_sided, ...
        'peakFrequency', peakFrequency);
end