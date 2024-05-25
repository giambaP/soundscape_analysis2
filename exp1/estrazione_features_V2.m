clc; clear all; close all

numOfDays = 31;

nomefs{1} = 'SpectralCentroid';
nomefs{2} = 'SpectralCrestFactor';
nomefs{3} = 'SpectralDecrease';
nomefs{4} = 'SpectralFlatness';
nomefs{5} = 'SpectralFlux';
nomefs{6} = 'SpectralRolloff';
nomefs{7} = 'SpectralSpread';
nomefs{8} = 'SpectralTonalPowerRatio';
nomefs{9} = 'TimeZeroCrossingRate';
nomefs{10} = 'TimeAcfCoeff';
nomefs{11} = 'TimeMaxAcf';
%nomefs{12} = 'SpectralMfccs';

featuresCount = length(nomefs);

nomeexp = './templatesYAT/PrimoExp';

% generating mat per feature
for fs=1:featuresCount
    featureName = nomefs{fs};
    fprintf('Creating feature %s \n', featureName);

    templateName = sprintf("%s_%s.mat", nomeexp, featureName);
    if ~exist(templateName, "file")
        counterRow = 1;

        clear featuresSet
        clear labels

        for YAT = 1:3
            fprintf('Extracting YAT %d\n',YAT);
            %audio per days
            for i = 1:numOfDays
                %audio per hours
                for j = [2 6 10 14 18 22]
                    %create file name
                    nm = '202003';
                    if i < 10
                        nm = strcat(nm,'0',num2str(i));
                    else
                        nm = strcat(nm,num2str(i));
                    end
                    if j < 10
                        nm = strcat(nm,'_0',num2str(j),'0000.WAV');
                    else
                        nm = strcat(nm,'_',num2str(j),'0000.WAV');
                    end
                    fprintf('%d) %s\n', counterRow, nm);

                    audioName = strcat('./databaseYAT/YAT', num2str(YAT),'Audible/',nm);
                    if exist(audioName, "file")
                        labels(counterRow) = YAT;

                        iBlockLength = 4096 * 8;
                        iHopLength = 2048 * 8;

                        [y, f_s] = audioread(audioName);
                        [X, f, t] = ComputeSpectrogram(y, f_s, [], iBlockLength, iHopLength);

                        switch fs
                            case 1
                                fsval = FeatureSpectralCentroid(X, f_s);
                            case 2
                                fsval = FeatureSpectralCrestFactor(X, f_s);
                            case 3
                                fsval = FeatureSpectralDecrease(X, f_s);
                            case 4
                                fsval = FeatureSpectralFlatness(X, f_s);
                            case 5
                                fsval = FeatureSpectralFlux(X, f_s);
                            case 6
                                fsval = FeatureSpectralRolloff(X, f_s);
                            case 7
                                fsval = FeatureSpectralSpread(X, f_s);
                            case 8
                                fsval = FeatureSpectralTonalPowerRatio(X, f_s);
                            case 9
                                fsval = FeatureTimeZeroCrossingRate(y, iBlockLength, iHopLength, f_s);
                            case 10
                                fsval = FeatureTimeAcfCoeff(y, iBlockLength, iHopLength, f_s);
                            case 11
                                fsval = FeatureTimeMaxAcf(y, iBlockLength, iHopLength, f_s);
                            case 12
                                fsMfcc = FeatureSpectralMfccs(X, f_s);
                        end
                        if(fs ~= 12)
                            featuresSet(counterRow,:) = fsval;
                        else
                            MfccsSet = [MfccsSet fsMfcc];
                        end
                        counterRow = counterRow + 1;
                    end
                end
            end
        end
        save(sname,'featuresSet','labels');
    end
end

data = [];
% concating all feature horizontally
for fs=1:featuresCount
    clear featuresSet
    clear labels

    featureName = nomefs{fs};
    fprintf('Creating feature %s \n', featureName);

    templateName = sprintf("%s_%s.mat", nomeexp, featureName);
    if ~exist(templateName, "file")
        error("feature file not exist: feature '%s'\n", featureName);
    end
    load(templateName);

    data = [data featuresSet];
    save('./templatesYAT/matriceYAT.mat', 'data', 'labels');
end

%% checking compatibility
disp("");
disp("-----  CHECKING COMPATIBILITY ----");
dirTemplateNew = "./templatesYAT";
dirTemplateOriginal = "./templatesYAT_ORIG";
fileList = dir(dirTemplateOriginal);
fileList = fileList(~[fileList.isdir]);
for i=1:length(fileList)
    fileName = fileList(i, :).name;
    fprintf("%d. checking file %s\n", i, fileName);

    origFilePath = sprintf("%s/%s", dirTemplateOriginal, fileName);
    newFilePath = sprintf("%s/%s", dirTemplateNew, fileName);
    if ~exist(newFilePath , "file")
        error("feature file not exist final path: feature '%s'\n", featureName);
    else
        data1 = load(origFilePath);
        data2 = load(newFilePath);

        fields1 = fieldnames(data1);
        fields2 = fieldnames(data2);

        if ~isequal(fields1, fields2)
            error("feature content files are different: file '%s', field '%s'", fileName, fields1);
        else
            isEqual = true;
            for j = 1:length(fields1)
                d1 = data1.(fields1{j});
                d2 = data2.(fields2{j});
                if ~isequal(d1, d2)
                    error("feature content fields are different: file '%s', field '%s', posJ:'%d'", ...
                        fileName, fields1{j}, j);
                end
            end
        end
    end
end
