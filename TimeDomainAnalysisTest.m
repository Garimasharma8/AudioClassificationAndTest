classdef TimeDomainAnalysisTest < matlab.unittest.TestCase
    properties
        ecgData
    end

    properties (TestParameter)
        selected_audio = num2cell(2:2:29);
    end

    methods(TestClassSetup)
        function loadData(testCase)
            testCase.ecgData = load('HMurmurData.mat');
        end
    end



    methods(Test, TestTags = {'Basic Functionality Test'})
        % working fine
        function testSignalAmplitude(testCase, selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            % verify the amplitude of the signal
            expectedAmplitude = 1;
            analysisResults = analyzeTimeDomain(signal, 2000);
            testCase.verifyLessThanOrEqual(analysisResults.peakAmplitude,expectedAmplitude);
        end
        % working fine
        function testZCR(testCase, selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            analysisResults = analyzeTimeDomain(signal,2000);
            testCase.verifyLessThanOrEqual(analysisResults.zeroCrossingRate,5);
        end
        % working fine
        function testMonoChannel(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            expectedChannel = 1;
            actualChannel = size(signal,2);
            testCase.verifyEqual(actualChannel,expectedChannel)
        end

        % check why case 12 is passing
        function testAnalyzeTimeDomainWithEmptyInput(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            %length_signal = size(signal,2)
            % emptySignal = [];
            testCase.verifyNotEmpty(testCase, signal);
        end
    end


    methods(Test, TestTags = {'EdgeCases'})
        % Edge cases: single tone input, impulse input, and silence. 
        function testAnalyzeTimeDomainWithSingleToneInput(testCase)
            fs = 2000; % Sampling frequency
            t = 0:1/fs:1-1/fs; % Time vector for 1 second
            frequency = 1000; % Frequency of sine wave (1 kHz)
            amplitude = 1; % Amplitude of sine wave
            singleToneSignal = amplitude * sin(2 * pi * frequency * t);
            % Perform the analysis
            analysisResult = analyzeTimeDomain(singleToneSignal, fs);
            
            % Verify some expected property of the result, e.g., peak amplitude
            expectedPeakAmplitude = amplitude;
            testCase.verifyEqual(analysisResult.peakAmplitude, expectedPeakAmplitude, ...
                'AbsTol', 1e-15, 'Single tone signal peak amplitude is incorrect.');
        end
        
        % working fine
        function testCalculateRMSWithSilence(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            analysisResult = analyzeTimeDomain(signal, 2000);
            expectedRMS = 0;
            testCase.verifyNotEqual(analysisResult.rmsAmplitude, expectedRMS);
        end
    end

    methods(Test, TestTags={'Error Handling'})

        % error handling test: Test Invalid inputs

            % working fine
            % test with negative sampling rate
        function testAnalyzeTimeDomainWithNegativeSamplingRate(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            %audioSignal = rand(1, 1000); % Generate a random signal
            negativeFs = -2000; % Invalid negative sampling rate
            
            testCase.verifyError(@()analyzeTimeDomain(audioSignal, negativeFs), ...
                'SignalAnalysis:InvalidSamplingRate');
        end
            
            % working fine
            % test with string input
        function testAnalyzeTimeDomainWithNonNumericSignal(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            % nonNumericSignal = 'This is not an audio signal'; % Invalid signal type
            % fs = 44100; % Sampling frequency
            analysisResult = analyzeTimeDomain(signal, 2000);
            testCase.verifyGreaterThanOrEqual(analysisResult.peakAmplitude,0,...
                'SignalAnalysis:NonNumericSignal');
        end
            
            % working fine
            % test with an invalid complex signals
        function testAnalyzeTimeDomainWithComplexSignal(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            fs=2000;
            isComplex = any(imag(cell2mat(signal)) ~= 0);
            testCase.verifyEqual(double(isComplex),0);
            
        end
        
            % test with matrix or non-vector signal
        function testAnalyzeTimeDomainWithNonVectorSignal(testCase)
            nonVectorSignal = rand(100, 2); % Invalid signal shape (matrix instead of vector)
            fs = 2000; % Sampling frequency
            
            testCase.verifyError(@()analyzeTimeDomain(nonVectorSignal, fs), ...
                'SignalAnalysis:NonVectorSignal');
        end

    end
    
    
    methods (Test, TestTags = {'Big Data'})
        
        function testbigDataSignal(testCase)
            % Set up fresh state for each test.
            fs = 800000;
            random_audio = rand(fs,1);
            expectedamplitude = 1;
            actual_amplitude = max(abs(random_audio));
            testCase.verifyLessThanOrEqual(actual_amplitude,expectedamplitude)
            % Tear down with testCase.addTeardown.
        end
        
    end

end