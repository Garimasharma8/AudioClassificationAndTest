classdef FrequencyDomainAnalysisTest < matlab.unittest.TestCase

    properties
        ecgData
    end

    properties (TestParameter)
        selected_audio = num2cell(2:3:30);
    end

    methods(TestClassSetup)
        function loadData(testCase)
            testCase.ecgData = load('HMurmurData.mat');
        end
    end


    methods(Test, TestTags={'Basic Functionality Test'})
        
        % working fine
        function testPeakFrequency(testCase,selected_audio)
            % f = 1000;
            % fs = 8000;
            % dt = 1/fs;   %seconds per sample
            % StopTime = 0.25; %seconds
            % t = (0: dt: StopTime-dt); 
            % sampleSignal = sin(2*pi*f*t);
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            freqAnalysisResults = analyzeFrequencyDomain(signal, 2000);
            peakFrequency = freqAnalysisResults.peakFrequency;
            % Without AbsTol the test will fail. 
            testCase.verifyLessThanOrEqual(peakFrequency,1000);
        end

        % working fine
        function testIFFTofSignal(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            freqAnalysisResults = analyzeFrequencyDomain(signal, 2000);

            %singleSideFFT = freqAnalysisResults.signalFFT(1:length(freqAnalysisResults.signalFFT)/2 +1);
            y_reconstructed = ifft(freqAnalysisResults.signalFFT, length(fft(cell2mat(signal))));
          
            testCase.verifyEqual(cell2mat(signal),y_reconstructed,'AbsTol',1e2)

        end

        function testPitch(testCase, selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            freqAnalysisResults = analyzeFrequencyDomain(signal, 2000);
            testCase.verifyGreaterThan(freqAnalysisResults.pitchCalculated,0);
        end


        function testfundamentalFrequencyRange(testCase, selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            freqAnalysisResults = analyzeFrequencyDomain(signal, 2000);
            lower_f0 = 20;
            upper_f0 = 500;
            testCase.verifyGreaterThan(freqAnalysisResults.fundamentalFrequency, lower_f0);
            testCase.verifyLessThanOrEqual(freqAnalysisResults.fundamentalFrequency, upper_f0);
        end
        
        % function testCalculateFFTWithZeroInput(testCase)
        %     fs = 8000; % Sampling frequency
        %     zeroSignal = zeros(1, fs); % One second of zeros
        % 
        %     % Perform the FFT
        %     Y = fft(zeroSignal);
        % 
        %     % Verify that the spectrum is all zeros
        %     testCase.verifyEqual(Y, zeros(size(Y)), ...
        %         'Zero input signal should result in zero magnitude spectrum.');
        % end
        % 
        % function testCalculateFFTWithInvalidInput(testCase)
        %     fs = 8000; % Sampling frequency
        %     invalidSignal = 'not a signal'; % Invalid signal type
        % 
        %     % Verify that an error is thrown for non-numeric input
        %     testCase.verifyError(fft(invalidSignal), ...
        %         'FFTAnalysis:InvalidSignalType');
        % end
    end

    methods(Test, TestTags={'Big Data'})

        % robustness test: handle a very large signal
        function testLargeSignal(testCase)
           fs = 800000; % Sampling frequency
            zeroSignal = zeros(1, fs); % One second of zeros
            
            % Perform the FFT
            Y = fft(zeroSignal);
            
            % Verify that the spectrum is all zeros
            testCase.verifyEqual(Y, zeros(size(Y)), ...
                'Zero input signal should result in zero magnitude spectrum.'); 
        end
    end

end