% function to analyze time domain signals
function analysisResults = analyzeTimeDomain(audioSignal, fs)
    % Check for empty input
     
    if size(audioSignal,2) ~=1
        audioSignal = audioSignal(:,1);
    end


    if isempty(audioSignal)
        error('SignalAnalysis:EmptyInput', 'The input signal cannot be empty.');
    end
    
    % Perform analysis operations
    peakAmplitude = max(abs(cell2mat(audioSignal)));
    rmsAmplitude = sqrt(mean(cell2mat(audioSignal).^2));
    zeroCrossingRate = sum(abs(diff(cell2mat(audioSignal) > 0))) / length(cell2mat(audioSignal));
    
    % Package the results into a structure
    analysisResults = struct(...
        'peakAmplitude', peakAmplitude, ...
        'rmsAmplitude', rmsAmplitude, ...
        'zeroCrossingRate', zeroCrossingRate);
end