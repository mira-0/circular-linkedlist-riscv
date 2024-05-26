
# Circular Linked List in RISC-V Assembly

This repository contains a simple implementation of a circular linked list in RISC-V assembly, specifically designed to handle chars.

## Input

Operations on the list can be done through an input string.<br>
Singular commands need to be separated by *'~'* and spaces between commands don't matter.

Example of input string:

```
"ADD(1) ~ ADD(a) ~ SDX ~ SSX ~ REV ~ DEL(1) ~ SORT ~ PRINT"
```

## Possible Operations 

- *ADD(char)* - Add a char at the end of the list.
- *DEL(char)* - Remove every instance of a specific char from the list.
- *PRINT* - Print the elements of the list.
- *SORT* - (Quicksort) Arrange the elements of the list in the following order:<br>
  * punctuation and special characters < numbers < lowercase letters < uppercase letters.
- *SDX* - Shift the elements of the list to the right.
- *SSX* - Shift the elements of the list to the left.
- *REV* - Reverse the order of elements in the list.
