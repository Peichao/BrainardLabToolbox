function validatedFileName = GLW_ValidateFileName(fileName, displayTypeID)
% validatedFileName = GLW_ValidateFileName(fileName, displayTypeID)
%
% Description:
% Validates a filename to make sure it's in the right format.
%
% Input:
% fileName (string|struct|cell array) - The filename(s) to be validated.
% displayTypeID (integer) - The display ID type of the GLWindow.
%   This value should be generated by GLW_ValidateDisplayType.
%
% Output:
% validatedFileName (cell array) - The validated filenames, each name in
%   its own cell.

switch displayTypeID
	case {GLWindow.DisplayTypes.Normal, GLWindow.DisplayTypes.BitsPP}
		if ~ischar(fileName)
			error('"fileName" must be a string, i.e. char array.');
		end
		
		% Convert to a cell array.
		fileName = {fileName};
		
	case {GLWindow.DisplayTypes.Stereo, GLWindow.DisplayTypes.StereoBitsPP}
		if isstruct(fileName)
			% Validate the fields in the fileName struct.
			GLW_ValidateStructFields(fileName, {'left', 'right'});
			
			fileName = {fileName.left, fileName.right};
		elseif iscell(fileName)
			if ndims(fileName) ~= 2 || ~all(size(fileName) == [1 2])
				error('fileName must be a 1x2 cell array.');
			end
		else
			error('In stereo mode fileName must be a struct or cell array.');
		end
		
	case GLWindow.DisplayTypes.HDR
		if isstruct(fileName)
			% Validate the fields in the fileName struct.
			GLW_ValidateStructFields(fileName, {'front', 'back'});
			
			fileName = {fileName.front, fileName.back};
		elseif iscell(fileName)
			if ndims(fileName) ~= 2 || ~all(size(fileName) == [1 2])
				error('fileName must be a 1x2 cell array.');
			end
		else
			error('In HDR mode fileName must be a struct or cell array.');
		end
		
	otherwise
		error('Invalid display type ID %d.\n', displayTypeID);
end

% Make sure each cell element is a string.
for i = 1:length(fileName)
	if ~ischar(fileName{i}) || size(fileName{i}, 1) ~=	1
		error('Each element of "fileName" must be a string.');
	end
end

validatedFileName = fileName;