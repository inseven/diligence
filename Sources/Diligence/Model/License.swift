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

import Foundation

public struct License: Identifiable, Hashable {

    public var id = UUID()

    public let name: String
    public let author: String
    public let text: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public init(name: String, author: String, text: String) {
        self.name = name
        self.author = author
        self.text = text
    }

    public init(_ name: String, author: String, text: String) {
        self.init(name: name, author: author, text: text)
    }

    public init(name: String, author: String, filename: String, bundle: Bundle = Bundle.main) {
        self.name = name
        self.author = author
        self.text = String(contentsOfBundleFile: filename, bundle: bundle)!
    }

    public init(_ name: String, author: String, filename: String, bundle: Bundle = Bundle.main) {
        self.init(name: name, author: author, filename: filename, bundle: bundle)
    }


}

extension Array where Element == License {

    /// Return an array ensuing the built-in Diligence license exists, and exists only once in the array.
    func includingDiligenceLicense() -> Array<License> {
        return Array(Set(self + [Legal.license]))
    }

}
