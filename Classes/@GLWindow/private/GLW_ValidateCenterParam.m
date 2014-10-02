function validatedCenterParam = GLW_ValidateCenterParam(desiredCenter, displayTypeID)
% GLW_ValidateCenterParam - Validates the Center property of an object.
%
% Syntax:
% validatedCenterParam = GLW_ValidateCenterParam(desiredCenter, displayTypeID)
%
% Description:
% Validates the Center property of an object taking into account the
% display type.
%
% Input:
% desiredCenter (Mx2|Mx3|cell array|struct) - The desired object center.
% displayTypeID (integer) - The desired display ID type of the GLWindow.
%     This value should be generated by GLWindow.GLW_ValidateDisplayType.
%
% Output:
% validatedCenterParam (Mx3) - The validated object center(s).


switch displayTypeID
	case {GLWindow.DisplayTypes.Normal, GLWindow.DisplayTypes.BitsPP}	
		if ~isnumeric(desiredCenter)
			error('"desiredCenter" must be a 1x2 or 1x3 array in Normal or BitsPP modes.');
		end
		
	case {GLWindow.DisplayTypes.Stereo, GLWindow.DisplayTypes.StereoBitsPP}
		if isstruct(desiredCenter)
			GLW_ValidateStructFields(desiredCenter, {'left', 'right'});
			
			% Make sure dimensions values are the same size for both
			% displays.
			if ~isequal(size(desiredCenter.left), size(desiredCenter.right))
				error('Center values must be the same size.');
			end
			
			desiredCenter = [desiredCenter.left ; desiredCenter.right];
		elseif iscell(desiredCenter)
			if ~GLW_CheckDims(desiredCenter, {[1 1], [1 2]})
				error('"desiredCenter" should be a 1 or 2 element cell array in Stereo mode.');
			end
			
			% If only one center value was passed, we'll duplicate it.
			if length(desiredCenter) == 1
				desiredCenter{2} = desiredCenter{1};
			end
			
			% Make sure dimensions values are the same size for both
			% displays.
			if ~isequal(size(desiredCenter{1}), size(desiredCenter{2}))
				error('Center values must be the same size.');
			end
			
			desiredCenter = [desiredCenter{1} ; desiredCenter{2}];
	
		elseif isnumeric(desiredCenter)
			% If there's only 1 center value, duplicate it.
			if size(desiredCenter, 1) == 1
				desiredCenter = [desiredCenter ; desiredCenter];
			end
		end
		
	case GLWindow.DisplayTypes.HDR
		if ~isnumeric(desiredCenter)
			error('"desiredCenter" must be a 1x2 or 1x3 in HDR mode.');
		end
		
		desiredCenter = [desiredCenter ; desiredCenter];
		
	case GLWindow.DisplayTypes.StereoHDR
% 		if isstruct(desiredCenter)
% 			% Make sure the right fields were specified.
% 			GLW_ValidateStructFields(desiredCenter, GLWindow.DisplayFields.StereoHDR);
% 			
% 			% Make sure all the fields are the same size.
% 			fnames = fieldnames(GLWindow.DisplayFields.StereoHDR);
% 			for i = 1:(length(fnames) - 1)
% 				assert(isequal(size(desiredCenter.(fnames{i})), size(desiredCenter.(fnames{i+1}))), ...
% 					'GLW_ValidateCenterParam:SizeMismatch', ...
% 					'Center values must be the same size as each other.');
% 			end
% 		elseif iscell(desiredCenter)
% 			% Make sure we have a vector.
% 			assert(GLW_CheckDims(desiredCenter, {[1 4] [4 1]}), ...
% 				'GLW_ValidateCenterParam:InvalidDims', ...
% 				'Center value passed as a cell array must be a %d element vector', ...
% 				
% 		end

		assert(isvector(desiredCenter) && GLW_CheckDims(desiredCenter, {[1 2] [1 3]}), ...
			'GLW_ValidateCenterParam:InvalidDims', ...
			'In StereoHDR mode, the center value must be a 1x2 or 1x3 vector.');
		
		% Format the center value to be a matrix containing a value for
		% each window of the stereo HDR.
		numColors = length(GLWindow.DisplayFields.StereoHDR);
		c = zeros(numColors, size(desiredCenter, 2));
		for i = 1:numColors
			c(i,:) = desiredCenter;
		end
		desiredCenter = c;
		
	otherwise
		error('Unsupported display type ID "%d".', displayTypeID);
end

% If the desired center lacks a Z component, we'll add one on and make it
% 0.
if size(desiredCenter, 2) == 2
	desiredCenter(:,3) = 0;
end

% Make sure our validated center matrix looks OK.
if ~GLW_CheckDims(desiredCenter, {[size(desiredCenter,1), 3]})
	error('"desiredCenter" must be a Mx3 matrix.');
end

validatedCenterParam = desiredCenter;