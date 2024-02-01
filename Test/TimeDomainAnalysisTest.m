classdef TimeDomainAnalysisTest < matlab.unittest.TestCase
    properties
        ecgData
    end

    properties (TestParameter)
        selected_audio = num2cell(1:1:30);
    end

    methods(TestClassSetup)
        function loadData(testCase)
            testCase.ecgData = load('HMurmurData.mat');
        end
    end



    methods(Test, TestTags = {'Basic Functionality Test'})
        % working fine
        function testSignalPeakAmplitude(testCase, selected_audio)
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
            testCase.verifyGreaterThanOrEqual(analysisResults.zeroCrossingRate,0);
        end
        % working fine
        function testMonoChannel(testCase,selected_audio)
            % for loop for testing if signal is legitimate
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            expectedChannel = 1;
            actualChannel = size(signal,2);
            testCase.verifyEqual(actualChannel,expectedChannel)
        end

        function testCalculateRMS(testCase,selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            analysisResult = analyzeTimeDomain(signal, 2000);
            LowerLimit = 0;
            testCase.verifyGreaterThanOrEqual(analysisResult.rmsAmplitude, LowerLimit);
        end

        function testRmsDBFS(testCase, selected_audio)
            data = testCase.ecgData;
            signal = data.T.Data(selected_audio);
            analysisResult = analyzeTimeDomain(signal, 2000);
            UpperLimit = 0;
            testCase.verifyLessThanOrEqual(analysisResult.rmsDBFS,UpperLimit);
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
        
    end

    methods(Test, TestTags={'Error Handling'})

             
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