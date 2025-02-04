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

public struct CreditSection: View {

    private var title: String?
    private var credits: [Credit]

    public init(_ title: String? = nil, _ people: [String]) {
        self.title = title
        self.credits = people.map { Credit($0) }
    }

    public init(_ title: String? = nil, _ credits: [Credit]) {
        self.title = title
        self.credits = credits
    }

    public init(_ title: String? = nil, @CreditsBuilder credits: () -> [Credit]) {
        self.title = title
        self.credits = credits()
    }

    public var body: some View {
        Section(header: title != nil ? Text(title!) : nil) {
            ForEach(credits) { credit in
                if let url = credit.url {
                    Link(credit.name, url: url)
                } else {
                    Text(credit.name)
                }
            }
        }
    }

}
