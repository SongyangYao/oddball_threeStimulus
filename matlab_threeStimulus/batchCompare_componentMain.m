function batchCompare_componentMain(fileNameFields, handles)

    %% DEBUG
    [~, handles.flags] = init_DefaultSettings(); % use a subfunction    
    if handles.flags.saveDebugMATs == 1
        debugMatFileName = 'tempComponentCompare.mat';
        if nargin == 0
            load('debugPath.mat')
            load(fullfile(path.debugMATs, debugMatFileName))
            close all
        else
            if handles.flags.saveDebugMATs == 1
                path = handles.path;
                save('debugPath.mat', 'path')
                save(fullfile(path.debugMATs, debugMatFileName))            
            end
        end
    end
        
    fieldValue = {'peakMeanAmplit'};
    erpComponent = {'N2'; 'N1'; 'P3_N2'};
    erpComponent = {'RT'};
    erpComponent = {'P3'};
    erpDataType = {'filt'};
    chsToPlot = {'Cz'; 'Pz'};

    for i = 1 : length(fieldValue)

        for j = 1 : length(erpComponent)

            for k = 1 : length(erpDataType)

                % Pull out the data, 'ERP Component'      
                [dataOut, auxOut, auxOutPowers] = batch_pullOut_ERP(fileNameFields, erpComponent{j}, erpDataType{k}, handles);

                    % this pulling out actually have to be done only once,
                    % move at some point outside the loop

                % Do the stats for those component
                % statsPer = 'trials';
                statsPer = 'session'; % average one session        
                stimulusType = {'target'; 'distracter'; 'standard'};                
                [statsOut, matricesSessionNorm] = batch_statsPerComponent(dataOut, statsPer, erpComponent{j}, erpDataType{k}, fieldValue{i}, fileNameFields, stimulusType, handles);        

                % PLOT
                chsToPlot = {'Cz'; 'Pz'};
                batch_plotIntensityComparisonMAIN(statsOut, matricesSessionNorm, statsPer, erpComponent{j}, erpDataType{k}, fieldValue{i}, fileNameFields, stimulusType, chsToPlot, handles)
                chsToPlot = {'Fz'; 'Oz'};
                batch_plotIntensityComparisonMAIN(statsOut, matricesSessionNorm, statsPer, erpComponent{j}, erpDataType{k}, fieldValue{i}, fileNameFields, stimulusType, chsToPlot, handles)

            end
        end
    end
    
    %% AUX
    
        % Preprocess and calculate stats
        [auxStat, auxStatPowers] = batch_preProcessAUX(auxOut, auxOutPowers, handles);
        
        % Plot
        batch_plotAuxScalars(auxStat, auxStatPowers, handles)