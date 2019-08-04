//: Playground - noun: a place where people can play

import UIKit
import Extensions
import RxRelay
import RxSwift
import PlaygroundSupport

var str = "Hello, playground"

let arr = [1,2]

arr.ex.appending(3) // [1, 2, 3]
    .ex.appending(contentsOf: [4,5]) // [1, 2, 3, 4, 5]
    .ex.inserting(6, at: 0) // [6, 1, 2, 3, 4, 5]
    .ex.inserting(contentsOf: [7,8], at: 0) // [7, 8, 6, 1, 2, 3, 4, 5]
//    .ex.inserted(9, at: 20) // Fatal error: Array index is out of range
    .ex.removing(at: 0) // [8, 6, 1, 2, 3, 4, 5]
    .ex.moving(at: 3, to: 0) // [2, 8, 6, 1, 3, 4, 5]
