*** REVERSE POLISH NOTATION ***
-------------------------------

In this notation, operands come first and operator follows them.
Example: 18 5 +

Incoming operands are pushed to stack. Then the operator uses the latest two operands.
Example: 18 5 3 24 +
After + operator comes, 3 and 24 are popped from stack and the result is pushed back.
Stack after operation: 18 5 27

Example: 18 5 3 24 + x
Stack after operations: 18 135

Detailed information on Wikipedia:
http://en.wikipedia.org/wiki/Reverse_Polish_notation


*** IN/OUT PROTOCOL ***
-----------------------

Data comes serially (1-bit).
After reset, when the signal is initially 0, there is no data or operator incoming.

If 1 and 0 come consecutively, it means that an 8-bit number will follow.
Most significant bit (MSB) comes first.
Example: ...1011111101...
The dots must be zero.
These are input bits on the timeline and incoming data is 253, which follows "10".
253 must be pushed to stack.

If two 1s come consecutively, it means that an operator is incoming.
Operator codes are in 2-bit.

00 -> clear stack
01 -> addition
10 -> multiplication
11 -> check

Examples:
clear    -> ...1100...
add      -> ...1101...
multiply -> ...1110...
check    -> ...1111...

After check comes, latest data is read (not popped) from stack and sent to output.
Again 1 and 0 must be sent before the 8-bit number.
Example: Stack = {1, 3, 5}
If check comes, 5 is popped to output as follows.
...1000000101...
5 stays in stack.


*** PORTS ***
-------------

There are four ports. Clock, reset, 1-bit input data and 1-bit output data.

module reversePolishNotation
(
   input  clk,
   input  rst,
   input  dIn,
   output dOut
);
