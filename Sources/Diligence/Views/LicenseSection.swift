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

import SwiftUI

import Licensable

public struct LicenseSection: View {

    var title: String?
    var licenses: [AnyLicensable]

    public init(_ title: String? = nil, _ licenses: [Licensable]) {
        self.title = title
        self.licenses = licenses.flatten().sortedByName().eraseToAnyLicensable()
    }

    public init(_ title: String? = nil, @LicensesBuilder licenses: () -> [Licensable]) {
        self.init(title, licenses())
    }

    public var body: some View {
        Section(header: title != nil ? Text(title ?? "") : nil) {
            ForEach(licenses) { license in
                LicenseRow(license)
            }
        }
    }

}
