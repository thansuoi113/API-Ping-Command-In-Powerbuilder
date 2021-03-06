$PBExportHeader$nvo_sizeof.sru
forward
global type nvo_sizeof from nonvisualobject
end type
end forward

global type nvo_sizeof from nonvisualobject autoinstantiate
end type

type variables
Private:
CONSTANT integer SIZE_BOOLEAN  = 1  // Boolean
CONSTANT integer SIZE_CHAR  = 1  // Char
CONSTANT integer SIZE_INT  = 2  // Signed integer
CONSTANT integer SIZE_UINT  = 2  // Unsigned integer
CONSTANT integer SIZE_LONG  = 4  // Signed Long
CONSTANT integer SIZE_ULONG  = 4  // Unsigned Long
CONSTANT integer SIZE_STRING  = 4  // Assume as string pointer
// Supported DataTypes
integer  INTEGER
uint  UINT
long  LONG
ulong   ULONG
char  CHAR
string  STRING
boolean  BOOLEAN
end variables
forward prototypes
public function long sizeof (long data)
public function long sizeof (unsignedlong data)
public function long sizeof (integer data)
public function long sizeof (unsignedinteger data)
public function long sizeof (character data)
public function long sizeof (string data)
public function long sizeof (boolean data)
public function long sizeof (any data[])
public function long sizeof (variabledefinition vardef[])
public function long sizeof (powerobject data)
end prototypes

public function long sizeof (long data);Return(SIZE_LONG)
end function

public function long sizeof (unsignedlong data);Return(SIZE_ULONG)

end function

public function long sizeof (integer data);Return(SIZE_INT)
end function

public function long sizeof (unsignedinteger data);Return(SIZE_UINT)
end function

public function long sizeof (character data);Return(SIZE_CHAR)
end function

public function long sizeof (string data);Return(SIZE_STRING)
end function

public function long sizeof (boolean data);Return(SIZE_BOOLEAN)
end function

public function long sizeof (any data[]);// Gives the dimension of an array
// Arguments: Data[] => Array to know the dimension
// Returns: Size of the array
// Notes:
// 1) Supports mixed type arrays (and variable sized strings within the array)
// 2) DOESN 'T support multi-dimension arrays;
Long ll_Index, ll_Count, ll_Size = 0

ll_Count = UpperBound(Data)
For ll_Index = 1 To ll_Count
	Choose Case ClassName(Data[ll_Index])
		Case "long"
			ll_Size += SizeOf(Long)
		Case "unsignedlong", "ulong"
			ll_Size += SizeOf(ULong)
		Case "int", "integer"
			ll_Size += SizeOf(Integer)
		Case "uint", "unsignedinteger", "unsignedint"
			ll_Size += SizeOf(UInt)
		Case "char", "character"
			ll_Size += SizeOf(Char)
		Case "string"
			ll_Size += SizeOf(Char) * SizeOf(String(Data[ll_Index]))
		Case "boolean"
			ll_Size += SizeOf(Boolean)
	End Choose
Next

Return(ll_Size)

end function

public function long sizeof (variabledefinition vardef[]);// Internal calculations for structure sizes
Long ll_Index, ll_Count, ll_Size, ll_Array = 0
ClassDefinition TypeInfo
VariableDefinition VarList[]
VariableCardinalityDefinition VarCarDef
ArrayBounds ArrBounds[]
String ls_typeof

ll_Count = UpperBound(VarDef)

For ll_Index = 2 To ll_Count //ll_Index=1 itself
	VarCarDef = VarDef[ll_Index].Cardinality
	If VarCarDef.Cardinality = BoundedArray! Then
		ArrBounds = VarCarDef.ArrayDefinition
		If UpperBound(ArrBounds) = 1 Then
			ll_Array = ArrBounds[1].UpperBound
		ElseIf UpperBound(ArrBounds) >= 2 Then //two dim array
			ll_Array = (ArrBounds[2].UpperBound)*(ArrBounds[1].UpperBound)
		End If
	Else //ScalarType! or UnboundedArray!
		ll_Array = 1
	End If
	ls_typeof = Lower(VarDef[ll_Index].TypeInfo.DataTypeOf)
	Choose Case ls_typeof
		Case "long"
			ll_Size += SizeOf(Long) * ll_Array
		Case "ulong", "unsignedlong"
			ll_Size += SizeOf(ULong) * ll_Array
		Case "int", "integer"
			ll_Size += SizeOf(Integer) * ll_Array
		Case "uint", "unsignedint", "unsignedinteger"
			ll_Size += SizeOf(UInt) * ll_Array
		Case "char", "character"
			ll_Size += SizeOf(Char) * ll_Array
		Case "string"
			ll_Size += SizeOf(String) * ll_Array
		Case "structure"
			TypeInfo = VarDef[ll_Index].TypeInfo
			VarList = TypeInfo.VariableList
			ll_Size += SizeOf(VarList)
		Case Else
			//if just store pointer in pb?? ll_Size+=(4*ll_Array)
			MessageBox( "SizeOf error ", "Type is not supported, possibly variable sized or object type! ",StopSign!,Ok!)
			Return (-1)
	End Choose
Next

Return(ll_Size)

end function

public function long sizeof (powerobject data);// This function calculates the size of a structure
// The structure can contain simple datatypes (long, integer, boolean), arrays or
// other structures within it
// Arguments: Data => Structure to know the size of..
// Returns: Size of the structure or -1 if error
// Notes:
// 1) Cannot calculate the size of a structure with strings (variable size), for fixed
// sized strings use a char array;
// 2) CAN calculate the size of multi-dimension arrays within the structures
ClassDefinition ClassDef
VariableDefinition VarDef[]

ClassDef = Data.ClassDefinition

If Not ClassDef.IsStructure Then Return - 1

VarDef = ClassDef.VariableList

Return(SizeOf(VarDef))


end function

on nvo_sizeof.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_sizeof.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

