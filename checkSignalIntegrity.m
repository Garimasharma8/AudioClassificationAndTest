function out = checkSignalIntegrity(audioSignal, fs)
    out = 0;

    n = length(audioSignal);

    if ischar(audioSignal) || ischar(fs)
        out = -2;
        %error('SignalAnalysis:Not a Numeric Signal','This signal is not numeric');
        return;
    end
    
    if numel(audioSignal) == 0 || numel(fs) ==0
        out = -1;
        %error('SignalAnalysis:Empty Input', 'The input signal cannot be empty.');
        return;
    end

    if ~isscalar(fs) || fs<=0
        out = -3;
        %error('SignalAnalysis:Negative Sampling Rate','This signal has 0 or negative sampling rate');
        return;
    end

    if any(imag(audioSignal) ~= 0)
        out = -4;
        %error('SignalAnalysis:Complex Signal','This is not a real signal');
        return;
    end

end
