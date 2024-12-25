# Homework 5: Digital Logic Design (Logism)

## Boolean Algebra 

### Part 1
Write a truth table for the following function: Output=`[(!C⋅B)⊕(A⊕(B⋅C))]+A⋅!C`. Implement this in Logism Evolution `circuit1a.circ`. 

### Part 2
Write a sum-of-products Boolean function for the output (out) in the following truth table. Use Logisim Evolution to implement this circuit `circuit1c.circ`. </br >
| A | B | C | out |
|---|---|---|-----|
| 0 | 0 | 0 |  1  |
| 0 | 0 | 1 |  0  |
| 0 | 1 | 0 |  1  |
| 0 | 1 | 1 |  0  |
| 1 | 0 | 0 |  1  |
| 1 | 0 | 1 |  0  |
| 1 | 1 | 0 |  0  |
| 1 | 1 | 1 |  1  |


## Adder/Subtractor Design
Use Logisim Evolution to build and test a 16-bit ripple-carry adder/subtractor. You must first create a 1-bit full adder that you then use as a module in the 16-bit adder. The unit should perform A+B if the sub input is zero, or A-B if the sub input is 1. The circuit should also output an overflow signal (ovf) indicating if there was a signed overflow.

## Finite State Machine
You’re an engineer at a robotics company that works with industrial robot arms, and you have been tasked to produce a finite state machine to control the arm. The arm moves left and right within a certain range of 4 positions. It starts at the far left at position 0, and it can go as far right as position 3. If you try to move the robot left from position 0, it just stays at position 0. Similarly, if you try to move the robot right from position 3, it just stays at position 3. </br >

At the start, the robot is not moving. The robot has a speed input that specifies how many positions the robot moves in one cycle. The robot starts at speed 0 (but is not moving, so this is the speed it will use by default once it starts moving, unless the speed is changed). You have two inputs: one enables you to choose between moving left and right, and the other enables you to control the speed. You have two outputs: the position of the robot and a signal to denote whether the robot was unable to move due to already being at the farthest position. </br >

The formal names you must use in your circuit are shown below. Please implement this circuit in Logism Evolution.  </br >

| Pin name       | Type        | Meaning                                                                                                                                                                                                                     |
|----------------|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **in_leftright** | 2-bit input | 01 if we want robot to move left; 10 if we want robot to move right; 00 if we don’t want robot to move at all; never 11                                                                                                    |
| **in_speed**    | 1-bit input | 0 means move by one position per cycle; 1 means move by two positions per cycle. <br> If in_speed=1 but only one position is available for movement (i.e., if requested to go left from position 1 or right from position 2), the robot will only move one position and then stop. |
| **out_position** | 2-bit output | Current position of robot. Starts at 0. Cannot be less than 0 or greater than 3.                                                                                                                                           |
| **out_blocked**  | 1-bit output | Set to 1 if robot was unable to move at all because it was requested to go left while at left end (position 0) or requested to go right while at right end (position 3). Set to 0 otherwise. <br> Note that out_blocked is set to 0 if the robot is able to move but not as far as requested (i.e., if it is at in_speed=1 but only one position is available for movement). |