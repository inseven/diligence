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

public struct Link: View {

    @Environment(\.openURL) private var openURL
    @Environment(\.prefersTextualRepresentation) private var prefersTextualRepresentation

    private let text: String
    private let url: URL

    private var isMailto: Bool {
        return url.scheme == "mailto"
    }

    private var image: String {
        if isMailto {
            return "envelope"
        }
        return "link"
    }

    public init(_ text: String, url: URL) {
        self.text = text
        self.url = url
    }

    public var body: some View {
#if os(iOS)
        Button {
            openURL(url)
        } label: {
            LabeledContent(text) {
                if #available(iOS 16, *, macOS 13) {
                    ViewThatFits(in: .horizontal) {
                        if prefersTextualRepresentation {
                            Text(url.absoluteString)
                        }
                        Image(systemName: image)
                    }
                    .foregroundColor(.secondary)
                } else {
                    Image(systemName: image)
                        .foregroundColor(.secondary)
                }
            }
        }
        .foregroundColor(.primary)
        .buttonStyle(.plain)
#else
        LabeledContent(text) {
            Text(url.absoluteString)
                .hyperlink {
                    openURL(url)
                }
        }
#endif
    }
}
