function out = checkSignalIntegrity(audioSignal, fs)
    out = 0;
    % out = -1: Empty signal
    % out = -2: Empty sampling rate
    % out = -3: Not a numeric signal
    % out = -4: Not a numeric sampling rate
    % out = -5: Negative Sampling rate
    % out = -6: Sampling rate is not scalar
    % out = -7: Complex Signal and sampling rate
    % out = -8: Complex signal and real sampling rate
    % out = -9: Complex sampling rate

    %n = length(audioSignal);

    if numel(audioSignal) == 0
        out = -1;
        %error('SignalAnalysis:Empty Input', 'The input signal cannot be empty.');
        return;
    end
    
    if numel(fs) ==0
        out = -2;
        %error('SignalAnalysis:Empty sampling rate','The sampling rate cannot be empty');
        return;
    end
    
    if ischar(audioSignal) 
        out = -3;
        %error('SignalAnalysis:Not a Numeric Signal','This signal is not numeric');
        return;
    end
    
    if ischar(fs)
        out = -4;
        %error('SignalAnalysis:Not a Numeric sampling rate','The sampling rate must be numeric');
        return;
    end

    if  fs<=0
        out = -5;
        %error('SignalAnalysis:Negative Sampling Rate','This signal has negative sampling rate');
        return;
    end

    if ~isscalar(fs)
        out = -6;
        %error('SignalAnalysis:Sampling rate is not scalar');
        return;
    end


    if any(imag(audioSignal)) && isreal(fs)
        out = -7;
        %error('SignalAnalysis:Complex signal ','The Signal cannot be complex');
        return;
    end

    if isreal(audioSignal) && any(imag(fs))
        out = -8;
        %error('SignalAnalysis: Complex sampling rate');
        return;
    end
    
    if any(imag(audioSignal)) || any(imag(fs))
        out = -9;
        %error('SignalAnalysis:Complex Signal and sampling rate','This is not a real signal');
        return;
    end

    




end
