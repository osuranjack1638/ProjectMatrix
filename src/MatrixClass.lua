local MatrixClass = {}
MatrixClass.__index = MatrixClass

type MatrixMethods = {
	RowCount: number,
	ColumnCount: number,
	Data: {{number}},
	Set: (self: Matrix, Row: number, Column: number, Value: number) -> (),
	Get: (self: Matrix, Row: number, Column: number) -> number,
	Copy: (self: Matrix) -> Matrix,
	Add: (self: Matrix, OtherMatrix: Matrix) -> Matrix,
	Subtract: (self: Matrix, OtherMatrix: Matrix) -> Matrix,
	Multiply: (self: Matrix, Other: number | Matrix) -> Matrix
}

type MatrixMetamethods = {
	__add: (Matrix, Matrix) -> Matrix,
	__sub: (Matrix, Matrix) -> Matrix,
	__mul: (Matrix, Matrix) -> Matrix,
	__div: (Matrix, Matrix | number) -> Matrix,
	__tostring: (Matrix) -> string,
	__eq: (Matrix) -> boolean
}

export type Matrix = typeof(setmetatable({} :: MatrixMethods, {} :: MatrixMetamethods))

type MatrixModule = {
	New: (Size: string, DefaultValue: number?) -> Matrix
}

local function ParseSizeString(SizeString: string): (number?, number?)
	if not SizeString then
		warn("[PROJECT MATRIX] No size was given while creating a matrix!")
		return nil, nil
	end

	SizeString = string.gsub(SizeString, "%s+", "") -- Remove spaces
	local RowString, ColumnString = string.match(SizeString, "^(%d+)x(%d+)$")

	if not RowString or not ColumnString then
		warn("[PROJECT MATRIX] Size string could not be read. Is it written right? (e.g: 2x2, 4x9...)")
		return nil, nil
	end

	local Rows = tonumber(RowString)
	local Columns = tonumber(ColumnString)
	if Rows <= 0 or Columns <= 0 then
		warn("[PROJECT MATRIX] A matrix must have a positive size!")
		return nil, nil
	end
	
	return Rows, Columns
end


function MatrixClass.New(Size: string, DefaultValue: number?): Matrix?
	local Rows, Columns = ParseSizeString(Size)
	if not Rows or not Columns then return end
	
	local self = setmetatable({}, MatrixClass)
	self.RowCount = Rows
	self.ColumnCount = Columns
	self.Data = {}
	
	DefaultValue = DefaultValue or 0
	
	for i = 1, Rows do
		self.Data[i] = {}
		for j = 1, Columns do
			self.Data[i][j] = DefaultValue
		end
	end
	
	return self
end

function MatrixClass:Set(Row: number, Column: number, Value: number): ()
	if not Row or not Column or Value == nil then
		warn("[PROJECT MATRIX] Row/Column/Value was not given while using the .Set() function!")
		return
	end
	
	self.Data[Row][Column] = Value
end

function MatrixClass:Get(Row: number, Column: number): number
	if not Row or not Column then
		warn("[PROJECT MATRIX] Row/Column was not given while using the .Get() function!")
		return
	end
	
	return self.Data[Row][Column]
end

function MatrixClass:Copy(): Matrix
	local SelfRowCount = self.RowCount
	local SelfColumnCount = self.ColumnCount
	
	local ResultSizeString = string.format("%dx%d", SelfRowCount, SelfColumnCount)
	local ResultMatrix = MatrixClass.New(ResultSizeString, 0)
	
	for Row = 1, SelfRowCount do
		for Column = 1, SelfColumnCount do
			ResultMatrix.Data[Row][Column] = self.Data[Row][Column]
		end
	end
	
	return ResultMatrix
end

function MatrixClass:Add(OtherMatrix: Matrix): Matrix
	if not OtherMatrix then
		warn("[PROJECT MATRIX] No matrix was given while using the .Add() function!")
		return self
	end
	
	local OtherMatrixRowCount = OtherMatrix.RowCount
	local OtherMatrixColumnCount = OtherMatrix.ColumnCount
	
	local SelfRowCount = self.RowCount
	local SelfColumnCount = self.ColumnCount
	
	if SelfRowCount ~= OtherMatrixRowCount or SelfColumnCount ~= OtherMatrixColumnCount then
		warn("[PROJECT MATRIX] Both matrices must be the same size to add them together!")
		return self
	end
	
	local ResultSizeString = string.format("%dx%d", SelfRowCount, SelfColumnCount)
	local ResultMatrix = MatrixClass.New(ResultSizeString, 0)
	if not ResultMatrix then return self end
	
	for Row = 1, SelfRowCount do
		for Column = 1, SelfColumnCount do
			local Sum = self.Data[Row][Column] + OtherMatrix.Data[Row][Column]
			ResultMatrix.Data[Row][Column] = Sum
		end
	end
	
	return ResultMatrix
end

function MatrixClass:Subtract(OtherMatrix: Matrix): Matrix
	if not OtherMatrix then
		warn("[PROJECT MATRIX] No matrix was given while using the .Subtract() function!")
		return self
	end

	local OtherMatrixRowCount = OtherMatrix.RowCount
	local OtherMatrixColumnCount = OtherMatrix.ColumnCount

	local SelfRowCount = self.RowCount
	local SelfColumnCount = self.ColumnCount

	if SelfRowCount ~= OtherMatrixRowCount or SelfColumnCount ~= OtherMatrixColumnCount then
		warn("[PROJECT MATRIX] Both matrices must be the same size to subtract them!")
		return self
	end

	local ResultSizeString = string.format("%dx%d", SelfRowCount, SelfColumnCount)
	local ResultMatrix = MatrixClass.New(ResultSizeString, 0)
	if not ResultMatrix then return self end

	for Row = 1, SelfRowCount do
		for Column = 1, SelfColumnCount do
			local NewValue = self.Data[Row][Column] - OtherMatrix.Data[Row][Column]
			ResultMatrix.Data[Row][Column] = NewValue
		end
	end

	return ResultMatrix
end

function MatrixClass:Multiply(Other: number | Matrix): Matrix
	if not Other then
		warn("[PROJECT MATRIX] No value was given while using the .Multiply() function!")
		return self
	end
	
	if typeof(Other) == "number" then
		local SelfRowCount = self.RowCount
		local SelfColumnCount = self.ColumnCount
		
		local ResultSizeString = string.format("%dx%d", SelfRowCount, SelfColumnCount)
		local ResultMatrix = MatrixClass.New(ResultSizeString)
		for Row = 1, self.RowCount do
			for Column = 1, self.ColumnCount do
				ResultMatrix.Data[Row][Column] = self.Data[Row][Column] * Other
			end
		end

		return ResultMatrix
	elseif typeof(Other) == "table" and (Other :: any).Data then
		local SelfRowCount = self.RowCount
		local SelfColumnCount = self.ColumnCount

		local OtherMatrixRowCount = Other.RowCount
		local OtherMatrixColumnCount = Other.ColumnCount

		if SelfColumnCount ~= OtherMatrixRowCount then
			warn(string.format("[PROJECT MATRIX] Cannot multiply matrices! Column count of first matrix (%d) must match row count of second matrix (%d).", SelfColumnCount, OtherMatrixRowCount))
			return self
		end

		local ResultSizeString = string.format("%dx%d", SelfRowCount, OtherMatrixColumnCount)
		local ResultMatrix = MatrixClass.New(ResultSizeString, 0)
		if not ResultMatrix then return self end

		for Row = 1, SelfRowCount do
			for Column = 1, OtherMatrixColumnCount do
				local Sum = 0
				for i = 1, SelfColumnCount do
					Sum = Sum + (self.Data[Row][i] * Other.Data[i][Column])
				end
				ResultMatrix.Data[Row][Column] = Sum
			end
		end

		return ResultMatrix
	end
end

function MatrixClass:Divide(Other: number): Matrix
	if not Other then
		warn("[PROJECT MATRIX] No value was given while using the .Divide() function!")
		return self
	end
	
	if Other == 0 then
		warn("[PROJECT MATRIX] Cannot divide a matrix by zero!")
		return self
	end
		
	local ResultMatrix = MatrixClass.New(string.format("%dx%d", self.RowCount, self.ColumnCount))
	for Row = 1, self.RowCount do
		for Column = 1, self.ColumnCount do
			ResultMatrix.Data[Row][Column] = self.Data[Row][Column] / Other
		end
	end
		
	return ResultMatrix
end

function MatrixClass:ToString(): string
	local OutputRows = {}
	table.insert(OutputRows, string.format("\n[Matrix %dx%d]", self.RowCount, self.ColumnCount))
	
	for i = 1, self.RowCount do
		local RowElements = {}
		for j = 1, self.ColumnCount do
			table.insert(RowElements, tostring(self.Data[i][j]))
		end
		
		table.insert(OutputRows, "["..table.concat(RowElements, ", ").."]")
	end
	
	return table.concat(OutputRows, "\n")
end

function MatrixClass:Equal(OtherMatrix: Matrix): boolean
	if not OtherMatrix then
		warn("[PROJECT MATRIX] No value was given while using the .Equal() function!")
		return false
	end
	
	if self.RowCount ~= OtherMatrix.RowCount or self.ColumnCount ~= OtherMatrix.ColumnCount then
		return false
	end
	
	for Row = 1, self.RowCount do
		for Column = 1, self.ColumnCount do
			if self.Data[Row][Column] ~= OtherMatrix.Data[Row][Column] then
				return false
			end
		end
	end
	
	return true
end


MatrixClass.__add = MatrixClass.Add
MatrixClass.__sub = MatrixClass.Subtract
MatrixClass.__mul = MatrixClass.Multiply
MatrixClass.__div = MatrixClass.Divide
MatrixClass.__tostring = MatrixClass.ToString
MatrixClass.__eq = MatrixClass.Equal

return (MatrixClass :: any) :: MatrixModule
