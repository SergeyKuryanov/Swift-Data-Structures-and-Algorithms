## Dijkstra Expression Evaluation

A remarkably simple algorithm that was developed by E. W. Dijkstra in the 1960s uses two stacks (one for operands and one for operators) to do this job. An expression consists of parentheses, operators, and oper- ands (numbers). Proceeding from left to right and taking these entities one at a time, we manipulate the stacks according to four possible cases, as follows:

* Push operands onto the operand stack.
* Push operators onto the operator stack.
* Ignore left parentheses.
* On encountering a right parenthesis, pop an operator, pop the requisite number
of operands, and push onto the operand stack the result of applying that opera-
tor to those operands
* After the final right parenthesis has been processed, there is one value on the stack, which is the value of the expression

```swift
extension Character {
    var isOperator: Bool {
        let operatorsSet = Set("+-*/")
        return operatorsSet.contains(self)
    }

    var isRightParenthesis: Bool {
        return self == ")"
    }
}

func evaluate(_ input: String) -> Int? {
    let operatorStack = Stack<Character>()
    let operandStack = Stack<Int>()

    for char in input {
        if let operand = Int(String(char)) {
            operandStack.push(operand)
        } else if char.isOperator {
            operatorStack.push(char)
        } else if char.isRightParenthesis {
            let rightOperator = operandStack.pop()!
            let leftOperator = operandStack.pop()!

            switch operatorStack.pop() {
            case "+":
                operandStack.push(leftOperator + rightOperator)
            case "-":
                operandStack.push(leftOperator - rightOperator)
            case "*":
                operandStack.push(leftOperator * rightOperator)
            default:
                operandStack.push(leftOperator / rightOperator)
            }
        }
    }

    return operandStack.pop()
}
```