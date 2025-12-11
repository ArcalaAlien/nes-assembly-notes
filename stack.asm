; THE NES' STACK FOLLOWS TWO FORMS:
;     EMPTY STACK CONVENTION
;     DESCENDING STACK
;
; This means a couple different things:
; The empty stack convention means that the
; stack pointer (the CPU register that keeps
; track of where in the stack we are) points
; to the first empty spot in the stack.
;
; The opposite of this, the full stack convention
; means that the stack pointer points to the first
; filled spot in the stack.
;
; What convention is being used determines which
; read / write order you'll use for each add (pull) /
; remove (pop).
;
; EMPTY STACK:
;   PUSH:
;       Store Value
;       Update Stack Pointer
;   POP:
;       Update Stack Pointer
;       Pull Value
; FULL STACK:
;   PUSH:
;       Update Stack Pointer
;       Store Value
;   PULL:
;       Pull Value
;       Update Stack Pointer
;
; A descending stack means that when an element
; is added (pushed) to the stack the stack pointer is
; DECREMENTED, and when an element is removed (popped)
; from the stack the stack pointer is INCREMENTED.
;
; The opposite of this, an ascending stack, means that
; when an element is pushed to the stack the stack pointer is
; INCREMENTED, and when an element is popped the
; stack pointer is DECREMENTED.
