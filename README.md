# PPAP

PPAP is a (maybe yet another) programming language inspired by https://www.youtube.com/watch?v=0E00Zuayv9Q

## Example

### PPAP

```
I have 80 Pen
I have 65 Apple

Uh! Put-Pen
Uh! Put-Pen
Uh! Put-Apple
Uh! Put-Pen
```

Result:

```
PPAP
```

### Echo

```
I have a Pen
I have an Apple
Apple-Pen
Uh! Pick-Pen          # Read a character
Uh! Put-Pen           # Print the character
Uh! Jump-Apple-Pen    # Loop
```

### FizzBuzz

[examples/fizbuzz.ppap](examples/fizbuzz.ppap)

## Language Spec

### Execution Model

- Unlimited number of registers
- 24-bits wide memory (initialized with 0)
- A PPAP program is executed line by line

TODO:

- Define range of a register value

### Comment

    # This is comment
    I have an Apple  # This is also comment

### Register declaration

Registers must be declared before use. For example, the following code
declares a register `Pen` with 5 as its initial value. (Note that register name must be singular even when the value is more than 1, and register value must be >= 0.)

    I have 5 Pen

Name of a register must:

- start with A-Z
- consist of A-Z, a-z, 0-9
- include 'p' or 'P'
- not a command verb (Replace, Compare, etc.)

There are some special forms for register value 0 and 1.

    I have no Pinapple   # Pinapple == 0

    I have Pinapple      # Pinapple == 1
    I have a Pinapple    # Pinapple == 1
    I have an Pinapple   # Pinapple == 1

Register values are always parsed as decimal, even when it starts with '0'.

It is allowed to declare a register with the same name. In this case, the latter will overwrite the register value.

    I have 3 Pen  # Pen == 3
    I have 5 Pen  # Pen == 5

### Labels

Labels are names joined with `-`. Each name must be previously declared as a register (You cannot set a label Apple-Pen when you don't have at least 1 Apple and Pen.)

Example:

    I have a Pen
    I have an Apple
    Apple-Pen                # A label
    
    I have a Pinapple
    Pen-Pinappple-Apple-Pen  # Another label

You can optionally prefix `Uh!` to a label.

    I have a Pen
    I have an Apple
    Uh! Apple-Pen

It is an error when two labels of the same name are declared.

### Command execution

A command execution starts with `Uh!` and a specific verb corresponding to the command described below.

#### MOV(Replace)

    Uh! Replace-A-B

Change the value of A to the value of B

Example:

    I have a Pen
    I have 5 Apple
    Uh! Replace-Pen-Apple   # Pen == 5

#### ADD(Append)

    Uh! Append-A-B

A += B

#### SUB(Rip)

    Uh! Rip-A-B

A -= B

#### MUL(Multiply)

    Uh! Multiply-A-B

A *= B

#### DIV(Chop)

    Uh! Chop-A-B

A /= B

#### STORE(Push)

    Uh! Push-A-B

Store the value of A to memory address B

#### LOAD(Pull)

    Uh! Pull-A-B

Load the value of memory address B into register A

#### PRINT(Print)

    Uh! Print-A

Print the value of A as a number

Example:

    I have 97 Apples
    Uh! Print-Apples
    #=> 97

#### PUTC(Put)

    Uh! Put-A

Print the character whose character code is A

Example:

    I have 97 Apples
    Uh! Put-Apples
    #=> a

Put can take more than one arguments.

    I have 97 Apples
    Uh! Put-Apples-Apples-Apples
    #=> aaa

#### GETC(Pick)

    Uh! Pick-A

Read a character from stdin and store its code to A

#### EQ(Compare)

    Uh! Compare-A-B

A = (A == B ? 1 : 0)

    Uh! Compare-A-B-C!

Jump to C if A == B

#### NE(Compare?)

`Compare` performes NE when suffixed `?`.

    Uh! Compare-A-B?

A = (A != B ? 1 : 0)

Use `!?` when you also want to jump (note: `?!` is not allowed.)

    Uh! Compare-A-B-C!?

Jump to C if A != B

#### GT(Superior)

    Uh! Superior-A-B

A = (A > B ? 1 : 0)

    Uh! Superior-A-B-C!

Jump to C if A > B

#### GE(Superior?)

    Uh! Superior-A-B?

A = (A >= B ? 1 : 0)

    Uh! Superior-A-B-C!?

Jump to C if A >= B

#### JMP(Jump)

    Uh! Jump-C

Jump to C

## Contributing

- Let me know if you have a nice keyword for LT/LE or MOD (it must include 'p')

## License

MIT

## Contact

https://github.com/yhara/ppap-lang
