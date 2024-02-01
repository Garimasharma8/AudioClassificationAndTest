classdef classifytest < matlab.unittest.TestCase
    properties
        ecgData
        trained_model
    end

    properties (TestParameter)
        selected_audio = num2cell(1:2:30);
    end

    methods(TestClassSetup)
        function loadData(testCase)
            testCase.ecgData = load('HMurmurData.mat');
            testCase.trained_model = load('trained_model.mat');
        end
    end

    methods(Test)
        function myclassifytest(testCase, selected_audio)
            data = testCase.ecgData;
            testCase.trained_model = testCase.trained_model;
            signal = data.T.Data(selected_audio);
            signal = cell2mat(signal);
            aFE = audioFeatureExtractor(SampleRate=data.T.fs(selected_audio), Window=hamming(1024,"periodic"),...
                  OverlapLength=512, ...
                  spectralCentroid=true,spectralEntropy=true, ...
                  spectralSkewness=true,shortTimeEnergy=true );
            test_data = extract(aFE,signal');
            pred = mypredict(testCase.trained_model.Mdl, test_data(1,:));
            %actual_value = [-1,1];
            % verifyTrue(ismember(pred,actual_value));
            assert(isequal(pred, 1) || isequal(pred, -1));
        
        end
    end




end
