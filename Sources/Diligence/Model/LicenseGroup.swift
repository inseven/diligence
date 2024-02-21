// Copyright (c) 2018-2024 Jason Morley
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

import SwiftUI

import Licensable

public struct LicenseGroup: Identifiable, Equatable {

    public static func == (lhs: LicenseGroup, rhs: LicenseGroup) -> Bool {
        return lhs.id == rhs.id
    }

    public let id = UUID()

    let title: String
    let licenses: [AnyLicensable]

    public init(_ title: String, includeDiligenceLicense: Bool = false, licenses: [Licensable]) {
        self.title = title
        if includeDiligenceLicense {
            self.licenses = licenses.includingDiligenceLicense().flatten().sortedByName().eraseToAnyLicensable()
        } else {
            self.licenses = licenses.flatten().sortedByName().eraseToAnyLicensable()
        }
    }

    public init(_ title: String, includeDiligenceLicense: Bool = false, @LicensesBuilder licenses: () -> [Licensable]) {
        self.init(title, includeDiligenceLicense: includeDiligenceLicense, licenses: licenses())
    }

}
