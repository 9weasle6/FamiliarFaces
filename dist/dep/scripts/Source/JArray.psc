
;/  Ordered collection of values (value is float, integer, string or another container).
    Inherits JValue functionality
/;
Scriptname JArray Hidden


;/  creates new container object. returns container identifier (integral number).
    identifier is the thing you will have to pass to the most of container's functions as first argument
/;
int function object() global native

;/  creates array of given size, filled with empty items
/;
int function objectWithSize(int size) global native

;/  creates new array that contains given values
    objectWithBooleans converts booleans into integers
/;
int function objectWithInts(int[] values) global native
int function objectWithStrings(string[] values) global native
int function objectWithFloats(float[] values) global native
int function objectWithBooleans(bool[] values) global native

;/  creates new array containing all values from source array in range [startIndex, endIndex)
/;
int function subArray(int object, int startIndex, int endIndex) global native

;/  adds values from source array into this array. if insertAtIndex is -1 (default behaviour) it adds to the end.
    if insertAtIndex >= 0 it appends values starting from insertAtIndex index
/;
function addFromArray(int object, int sourceArray, int insertAtIndex=-1) global native

;/  returns item at index. getObj function returns container.
    negative index accesses items from the end of array counting backwards.
/;
int function getInt(int object, int index) global native
float function getFlt(int object, int index) global native
string function getStr(int object, int index) global native
int function getObj(int object, int index) global native
form function getForm(int object, int index) global native

;/  returns index of the first found value/container that equals to given value/container (default behaviour if searchStartIndex is 0).
    if found nothing returns -1.
    searchStartIndex - array index where to start search
    negative index accesses items from the end of array counting backwards.
/;
int function findInt(int object, int value, int searchStartIndex=0) global native
int function findFlt(int object, float value, int searchStartIndex=0) global native
int function findStr(int object, string value, int searchStartIndex=0) global native
int function findObj(int object, int container, int searchStartIndex=0) global native
int function findForm(int object, form value, int searchStartIndex=0) global native

;/  replaces existing value/container at index with new value.
    negative index accesses items from the end of array counting backwards.
/;
function setInt(int object, int index, int value) global native
function setFlt(int object, int index, float value) global native
function setStr(int object, int index, string value) global native
function setObj(int object, int index, int container) global native
function setForm(int object, int index, form value) global native

;/  appends value/container to the end of array.
    if addToIndex >= 0 it inserts value at given index. negative index accesses items from the end of array counting backwards.
/;
function addInt(int object, int value, int addToIndex=-1) global native
function addFlt(int object, float value, int addToIndex=-1) global native
function addStr(int object, string value, int addToIndex=-1) global native
function addObj(int object, int container, int addToIndex=-1) global native
function addForm(int object, form value, int addToIndex=-1) global native

;/  returns number of items in array
/;
int function count(int object) global native

;/  removes all items from array
/;
function clear(int object) global native

;/  erases item at index. negative index accesses items from the end of array counting backwards.
/;
function eraseIndex(int object, int index) global native