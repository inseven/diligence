// Copyright (c) 2018-2023 InSeven Limited
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

final class DiligenceTests: XCTestCase {

    func testEquivalence() {

        XCTAssertNotEquivalent([License("Fromage", author: "Fromage", text: "skdjfh")],
                               [License("Cheese", author: "Fromage", text: "skdjfh")])

        XCTAssertNotEquivalent([License("Cheese", author: "Fromage", text: "skdjfh")],
                               [License("Cheese", author: "Fromage", text: "skdjfkjshdfh")])

        XCTAssertNotEquivalent([License("Cheese", author: "Fromage", text: "skdjfh")],
                            [License("Cheese", author: "Random", text: "skdjfh")])

        XCTAssertEquivalent([License("Cheese", author: "Fromage", text: "skdjfh")],
                            [License("Cheese", author: "Fromage", text: "skdjfh")])
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
                                Diligence.Legal.license,
                            ])])
    }

    func testLicenseGroup() {

        let licenseGroup = LicenseGroup("Fonts") {
            License("One", author: "Two", text: "Three")
            License("Four", author: "Five", text: "Six")
        }
        XCTAssertEqual(licenseGroup.title, "Fonts")
        XCTAssertEquivalent(licenseGroup.licenses, [
            License("Four", author: "Five", text: "Six"),
            License("One", author: "Two", text: "Three"),
        ])

    }

    func testLicenseGroupIncludingDiligenceLicense() {

        let licenseGroup = LicenseGroup("Fonts", includeDiligenceLicense: true) {
            License("One", author: "Two", text: "Three")
            License("Four", author: "Five", text: "Six")
        }
        XCTAssertEqual(licenseGroup.title, "Fonts")
        XCTAssertEquivalent(licenseGroup.licenses, [
            Diligence.Legal.license,
            License("Four", author: "Five", text: "Six"),
            License("One", author: "Two", text: "Three"),
        ])
    }

}
