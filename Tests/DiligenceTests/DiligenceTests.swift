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
@testable import Diligence

import Licensable

final class DiligenceTests: XCTestCase {

    func testEquivalence() {

        XCTAssertNotEquivalent([License("Fromage", author: "Fromage", text: "skdjfh")].eraseToAnyLicensable(),
                               [License("Cheese", author: "Fromage", text: "skdjfh")].eraseToAnyLicensable())

        XCTAssertNotEquivalent([License("Cheese", author: "Fromage", text: "skdjfh")].eraseToAnyLicensable(),
                               [License("Cheese", author: "Fromage", text: "skdjfkjshdfh")].eraseToAnyLicensable())

        XCTAssertNotEquivalent([License("Cheese", author: "Fromage", text: "skdjfh")].eraseToAnyLicensable(),
                            [License("Cheese", author: "Random", text: "skdjfh")].eraseToAnyLicensable())

        XCTAssertEquivalent([License("Cheese", author: "Fromage", text: "skdjfh")].eraseToAnyLicensable(),
                            [License("Cheese", author: "Fromage", text: "skdjfh")].eraseToAnyLicensable())
    }

    func testContents() {
        let contents = Contents(repository: "foo/bar",
                                copyright: "Copyright") {
            Action("Website", url: URL(string: "https://example.com")!)
        } acknowledgements: {
            Acknowledgements("Thanks") {
                Credit("The World")
            }
        } licenses: {
            License("Name", author: "Author", text: "License")
        }

        XCTAssertEquivalent(contents.licenseGroups,
                            [LicenseGroup("Licenses", licenses: [
                                License("Name", author: "Author", text: "License"),
                                .diligence,
                            ])])
    }

    func testLicenseGroup() {

        let licenseGroup = LicenseGroup("Fonts") {
            License("One", author: "Two", text: "Three").eraseToAnyLicensable()
            License("Four", author: "Five", text: "Six").eraseToAnyLicensable()
        }
        XCTAssertEqual(licenseGroup.title, "Fonts")
        XCTAssertEquivalent(licenseGroup.licenses, [
            License("Four", author: "Five", text: "Six").eraseToAnyLicensable(),
            License("One", author: "Two", text: "Three").eraseToAnyLicensable(),
        ])

    }

    func testLicenseGroupIncludingDiligenceLicense() {

        let licenseGroup = LicenseGroup("Fonts", includeDiligenceLicense: true) {
            License("One", author: "Two", text: "Three")
            License("Four", author: "Five", text: "Six")
        }
        XCTAssertEqual(licenseGroup.title, "Fonts")

        let expected: [Licensable] = [
            .diligence,
            License("Four", author: "Five", text: "Six"),
            .licensable,
            License("One", author: "Two", text: "Three"),
        ]
        XCTAssertEquivalent(licenseGroup.licenses, expected.eraseToAnyLicensable())
    }

}
