// Clojures Playground

import Cocoa

func square(a:Float) -> Float {
    return a * a
}

func cube(a:Float) -> Float {
    return a * a * a
}

func averageSumOfSquares(a:Float,b:Float) -> Float {
    return (square(a: a) + square(a: b)) / 2.0
}

func averageSumOfCubes(a:Float,b:Float) -> Float {
    return (cube(a: a) + cube(a: b)) / 2.0
}


averageSumOfSquares(a: 3, b: 4)
averageSumOfCubes(a: 3, b: 4)

func averageOfFunction(a:Float,b:Float,f:((Float) -> Float)) -> Float {
    return (f(a) + f(b)) / 2
}

averageOfFunction(a: 3, b: 4, f: square)
averageOfFunction(a: 3, b: 4, f: cube)

averageOfFunction(a: 3, b: 4, f: {(x: Float) -> Float in return x * x})
averageOfFunction(a: 3, b: 4, f: {x in return x * x})


averageOfFunction(a: 3, b: 4, f: {x in x * x})
averageOfFunction(a: 3, b: 4, f: {$0 * $0})

var moneyArray = [10,20,45,32]

var stringsArray : Array<String> = []
for money in moneyArray {
    stringsArray.append("\(money)€")
}

print(stringsArray)

stringsArray = moneyArray.map({ "\($0)€" })
stringsArray = moneyArray.map({money in "\(money)€"})

print(stringsArray)

var filteredArray : Array<Int> = []

for money in moneyArray {
    if (money > 30) {
        filteredArray.append(money)
    }
}

print(filteredArray)

filteredArray = moneyArray.filter({$0 > 30})

print(filteredArray)

var sum = 0
for money in moneyArray {
    sum += money
}

print(sum)

sum = moneyArray.reduce(0,{$0 + $1})

sum = moneyArray.reduce(0,+)

print(sum)
