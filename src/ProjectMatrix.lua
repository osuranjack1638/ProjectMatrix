local ProjectMatrix = {}

local MatrixClass = require(script.MatrixClass)

export type Matrix = MatrixClass.Matrix

function ProjectMatrix.CreateMatrix(Size: string, DefaultValue: number?): Matrix
	if not Size then
		warn("[PROJECT MATRIX] No size was given while creating a matrix!")
		return nil :: any
	end

	local Matrix = MatrixClass.New(Size, DefaultValue)

	return Matrix :: any
end


return ProjectMatrix
