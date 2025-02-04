// Copyright (c) 2018-2025 Jason Morley
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest

import Licensable

@testable import Diligence

protocol Equivalence {

    func isEquivalent(_ other: Self) -> Bool

}

extension Array: Equivalence where Element: Equivalence {

    func isEquivalent(_ other: Array<Element>) -> Bool {
        return elementsEqual(other) { lhs, rhs in
            return lhs.isEquivalent(rhs)
        }
    }

}

extension LicenseGroup: Equivalence {

    func isEquivalent(_ other: LicenseGroup) -> Bool {
        return (self.title == other.title &&
                self.licenses.isEquivalent(other.licenses))
    }

}

extension AnyLicensable: Equivalence {

    func isEquivalent(_ other: AnyLicensable) -> Bool {
        return (self.name == other.name &&
                self.author == other.author &&
                self.text == other.text)
    }

}

func XCTAssertEquivalent<T>(_ expression1: @autoclosure () -> T,
                            _ expression2: @autoclosure () -> T,
                            _ message: @autoclosure () -> String = "",
                            file: StaticString = #filePath,
                            line: UInt = #line) where T : Equivalence {
    let value1 = expression1()
    let value2 = expression2()
    if value1.isEquivalent(value2) {
        return
    }
    XCTFail("\(value1) is not equivalent to \(value2)", file: file, line: line)
}

func XCTAssertNotEquivalent<T>(_ expression1: @autoclosure () -> T,
                            _ expression2: @autoclosure () -> T,
                            _ message: @autoclosure () -> String = "",
                            file: StaticString = #filePath,
                            line: UInt = #line) where T : Equivalence {
    let value1 = expression1()
    let value2 = expression2()
    if !value1.isEquivalent(value2) {
        return
    }
    XCTFail("\(value1) is equivalent to \(value2)", file: file, line: line)
}
