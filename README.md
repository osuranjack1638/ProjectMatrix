# Project Matrix

Project Matrix is a module for Roblox that can do operations with matrices, allowing developers to use matrices on their games/systems.

---

## Features
- Easy Usage
- Addition, Subtraction and Multiplication support
- OOP Based Structure
- Metamethods

---

## Functions

### ProjectMatrix.CreateMatrix()
Creates a new matrix.

Takes 2 parameters:
Size and DefaultValue

Size is the size of the matrix. <br>
DefaultValue is the value to use for each cell in the matrix when it's created. <br>

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local Matrix = ProjectMatrix.CreateMatrix("2x2", 0)
-- // This creates a 2x2 matrix with 0 as the default value.
```

### Matrix:Set()
Sets a cell on the matrix to a given value.

Takes 3 parameters:
Row, Column and Value.

Row, is the row of the cell you want to change. <br>
Column, is the column of the cell you want to change. <br>
Value, is the new value that you will change the cell to. <br>

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local Matrix = ProjectMatrix.CreateMatrix("2x2", 0)
Matrix:Set(1, 1, 9)
-- // This sets the cell that is found on Row 1 and Column 1 to 9.
```

### Matrix:Get()
Gets the value of the cell.

Takes 2 parameters:
Row and Column.

Row, is the row of the cell you want to get the value of. <br>
Column, is the column of the cell you want to get the value of. <br>

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local Matrix = ProjectMatrix.CreateMatrix("2x2", 0)
Matrix:Set(1, 1, 9)
print(Matrix:Get(1, 1)
-- // This prints 1 because we just changed that cell to be 9.
print(Matrix:Get(1, 2)
-- // This prints 0 because we never changed this cell and the default value for it was 0.
```

### Matrix:Copy()
Copies the matrix 1:1.

Does not take any parameters.

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local Matrix = ProjectMatrix.CreateMatrix("2x2", 0)
local CopiedMatrix = Matrix:Copy()
-- // Matrix and CopiedMatrix are the same.
-- // CopiedMatrix is NOT a pointer to Matrix. It is it's own object.
-- // Any operations done on CopiedMatrix does NOT affect Matrix.
```

---

## Mathematical Operations
**NOTE:** All the operations here can be found as a standalone function too. They weren't on the functions tab because I didn't want to make the file long.

### Addition
Adds 2 matrices together.

Function name: Add()

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local MatrixA = ProjectMatrix.CreateMatrix("2x2", 0)
local MatrixB = ProjectMatrix.CreateMatrix("2x2", 3)

-- // Let's assign some values:
MatrixA:Set(2, 1, 8)
MatrixA:Set(1, 1, 4)
MatrixA:Set(2, 2, 5)

MatrixB:Set(2, 1, 2)
MatrixB:Set(1, 2, 4)

local MatrixC = MatrixA + MatrixB
-- // Adds both matrices together
```

### Subtraction
Subtracts 2 matrices together.

Function name: Subtract()

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local MatrixA = ProjectMatrix.CreateMatrix("2x2", 0)
local MatrixB = ProjectMatrix.CreateMatrix("2x2", 3)

-- // Let's assign some values:
MatrixA:Set(2, 1, 8)
MatrixA:Set(1, 1, 4)
MatrixA:Set(2, 2, 5)

MatrixB:Set(2, 1, 2)
MatrixB:Set(1, 2, 4)

local MatrixC = MatrixA - MatrixB
-- // Subtracts both matrices together
```

### Multiplication
Multiplies 2 matrices together or multiplies a matrix with a number.

Function name: Multiply()

**Usage:**
```lua
local ProjectMatrix = require(Path.to.ProjectMatrix)

local MatrixA = ProjectMatrix.CreateMatrix("2x2", 0)
local MatrixB = ProjectMatrix.CreateMatrix("2x2", 3)

-- // Let's assign some values:
MatrixA:Set(2, 1, 8)
MatrixA:Set(1, 1, 4)
MatrixA:Set(2, 2, 5)

MatrixB:Set(2, 1, 2)
MatrixB:Set(1, 2, 4)

local MatrixC = MatrixA * MatrixB
-- // Multiplies both matrices together
local MatrixD = MatrixC * 2
-- // Multiplies MatrixC with 2
```
