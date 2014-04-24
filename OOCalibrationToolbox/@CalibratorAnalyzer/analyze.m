% Method to analyze the loaded calStruct
function obj = analyze(obj, calStruct)

    if (strcmp(calStruct.describe.driver, 'object-oriented calibration'))
        % set the @Calibrator's cal struct. The cal setter method also sets 
        % various other properties of obj
        obj.cal = calStruct;
    else
        % set the @Calibrator's cal struct to empty
        obj.cal = [];
        % and notify user
        calStruct.describe
        fprintf('The selected cal struct has an old-style format.\n');
        fprintf('Use ''mglAnalyzeMonCalSpd'' to analyze/plot it instead.\n');
        return;
    end
    
    obj.refitData();
    obj.computeReusableQuantities();  
    obj.plotAllData();
end