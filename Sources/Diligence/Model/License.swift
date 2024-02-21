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

import Foundation

import Licensable

// TODO: Attributes need to be identifiable

extension Attribute: Identifiable {

    public var id: String {
        return name
    }

}

// TODO: Implement this

extension Attribute.Value {

    public static func == (lhs: Attribute.Value, rhs: Attribute.Value) -> Bool {
        // TODO: THIS IS WRONG
        return true
    }

}

extension Attribute: Equatable {

    public static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }

}

public struct License: Identifiable, Hashable, Licensable {

    public var id = UUID().uuidString

    public let name: String
    public let author: String
    public let text: String
    public let attributes: [Attribute]

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public init(name: String, author: String, attributes: [NamedURL] = [], text: String) {
        self.name = name
        self.author = author
        self.attributes = attributes.map { namedURL in
            return .url(namedURL.url, title: namedURL.name)
        }
        self.text = text
    }

    public init(_ name: String, author: String, attributes: [NamedURL] = [], text: String) {
        self.init(name: name, author: author, attributes: attributes, text: text)
    }

    public init(name: String, author: String, attributes: [NamedURL] = [], filename: String, bundle: Bundle = Bundle.main) {
        self.name = name
        self.author = author
        self.attributes = attributes.map { namedURL in
            return .url(namedURL.url, title: namedURL.name)
        }
        self.text = String(contentsOfBundleFile: filename, bundle: bundle)!
    }

    public init(_ name: String,
                author: String,
                attributes: [NamedURL] = [],
                filename: String,
                bundle: Bundle = Bundle.main) {
        self.init(name: name, author: author, attributes: attributes, filename: filename, bundle: bundle)
    }

    public init(_ name: String, author: String, attributes: [NamedURL] = [], url: URL) {
        self.name = name
        self.author = author
        self.attributes = attributes.map { namedURL in
            return .url(namedURL.url, title: namedURL.name)
        }
        self.text = try! String(contentsOf: url)
    }

}

extension License {

    public init(_ licensable: Licensable) {
        self.init(licensable.name, author: licensable.author, text: licensable.text)
    }

}

extension Array where Element == Licensable {

    /// Return an array ensuing the built-in Diligence license exists, and exists only once in the array.
    func includingDiligenceLicense() -> [Licensable] {
        return self + [Legal.license]
    }

    /// Sort licenses alphabetically by name.
    func sorted() -> [Licensable] {
        return sorted {
            $0.name.localizedCompare($1.name) == .orderedAscending
        }
    }

}
