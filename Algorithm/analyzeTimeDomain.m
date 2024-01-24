% function to analyze time domain signals
function analysisResults = analyzeTimeDomain(audioSignal, fs)
    analysisResults = struct('peakAmplitude', -1, ...
        'rmsAmplitude', -1, ...
        'rmsDBFS',2,...
        'zeroCrossingRate', -1, 'status', 0);

    % convert audio signal to matrix if it is stored in a cell
    if iscell(audioSignal)
        audioSignal = cell2mat(audioSignal);
    else
        audioSignal = audioSignal;
    end
    % 
    % % Convert audio signal to mono channel
    % if size(audioSignal,1) ~=1
    %     audioSignal = audioSignal(1,:);
    % end



    analysisResults.status = checkSignalIntegrity(audioSignal,fs);
    
    % if (out==0)
    %     sFE = signalTimeFeatureExtractor(SampleRate=fs,FrameSize=1024,FrameOverlapLength=512,...
    %         Mean=true,RMS=true,SNR=true,PeakValue=true);
    %     analysisResults = extract(sFE,audioSignal);
    % else 
    %     disp('The time domain analysis for the signal is not posible');
    %     return
    % end


    if (analysisResults.status==0)
       peakAmplitude = max(abs(audioSignal));
       rmsAmplitude = sqrt(mean(audioSignal).^2);
       % DBFS = Decible related to full scale, upper bound of 0 dbfs
       rmsDBFS = 20 * log10(rmsAmplitude/peakAmplitude);
       zeroCrossingRate = sum(abs(diff(audioSignal > 0))) / length(audioSignal);
       
        % The murmur duration ranges between 0.080 to 0.150 secs. 
        % Package the results into a structure
        analysisResults.peakAmplitude = peakAmplitude;
        analysisResults.rmsAmplitude = rmsAmplitude;
        analysisResults.rmsDBFS = rmsDBFS;
        analysisResults.zeroCrossingRate = zeroCrossingRate;
              
    else 
        disp('Error: The time domain analysis for the signal is not posible');
    end


    % 
    % 
    % 
    % if isempty(audioSignal)
    %     error('SignalAnalysis:EmptyInput', 'The input signal cannot be empty.');
    % end
    % 
    % % Perform analysis operations
    % peakAmplitude = max(abs(cell2mat(audioSignal)));
    % rmsAmplitude = sqrt(mean(cell2mat(audioSignal).^2));
    % zeroCrossingRate = sum(abs(diff(cell2mat(audioSignal) > 0))) / length(cell2mat(audioSignal));
    % 
    % % Package the results into a structure
    % analysisResults = struct(...
    %     'peakAmplitude', peakAmplitude, ...
    %     'rmsAmplitude', rmsAmplitude, ...
    %     'zeroCrossingRate', zeroCrossingRate);
end