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

public struct License: Identifiable, Licensable {

    public var id: String
    public let name: String
    public let author: String
    public let text: String
    public let attributes: [Attribute]
    public let licenses: [Licensable]

    public init(id: String = UUID().uuidString,
                name: String,
                author: String,
                attributes: [NamedURL] = [],
                text: String,
                licenses: [Licensable] = []) {
        self.id = id
        self.name = name
        self.author = author
        self.attributes = attributes.map { namedURL in
            return .url(namedURL.url, title: namedURL.name)
        }
        self.text = text
        self.licenses = licenses
    }

    public init(_ name: String,
                author: String,
                attributes: [NamedURL] = [],
                text: String,
                licenses: [Licensable] = []) {
        self.init(name: name, author: author, attributes: attributes, text: text, licenses: licenses)
    }

    public init(id: String = UUID().uuidString,
                name: String,
                author: String,
                attributes: [NamedURL] = [],
                filename: String,
                bundle: Bundle = Bundle.main,
                licenses: [Licensable] = []) {
        self.id = id
        self.name = name
        self.author = author
        self.attributes = attributes.map { namedURL in
            return .url(namedURL.url, title: namedURL.name)
        }
        self.text = String(contentsOfBundleFile: filename, bundle: bundle)!
        self.licenses = licenses
    }

    public init(_ name: String,
                author: String,
                attributes: [NamedURL] = [],
                filename: String,
                bundle: Bundle = Bundle.main) {
        self.init(name: name, author: author, attributes: attributes, filename: filename, bundle: bundle)
    }

    public init(_ name: String, author: String, attributes: [NamedURL] = [], url: URL, licenses: [Licensable] = []) {
        self.id = UUID().uuidString
        self.name = name
        self.author = author
        self.attributes = attributes.map { namedURL in
            return .url(namedURL.url, title: namedURL.name)
        }
        self.text = try! String(contentsOf: url)
        self.licenses = licenses
    }

}
