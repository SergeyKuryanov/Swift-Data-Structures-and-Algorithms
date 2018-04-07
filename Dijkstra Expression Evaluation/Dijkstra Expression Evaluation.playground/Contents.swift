import Foundation

class Stack<T> {
    private var array = Array<T>()
    var count: Int {
        return array.count
    }

    func pop() -> T? {
        return array.removeLast()
    }

    func push(_ value: T) {
        array.append(value)
    }
}

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

evaluate("((1 + 2) * 3)")
evaluate("(1 + ((2 + 3) * (4 * 5)))")
