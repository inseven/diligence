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

#if compiler(>=5.7) && os(macOS)

@available(macOS 13, *)
struct MacLicenseView: View {

    private struct LayoutMetrics {
        static let fontSize = 12.0
        static let maximumWidth = 720.0
        static let minimumHeight = 300.0
        static let interItemSpacing = 16.0
    }

    var license: Licensable

    var body: some View {
        ScrollView {
            VStack(spacing: LayoutMetrics.interItemSpacing) {
                LabeledContent("Author", value: license.author)
                ForEach(license.attributes) { attribute in
                    switch attribute.value {
                    case .text(let text):
                        LabeledContent(attribute.name, value: text)
                    case .url(let url):
                        Link(attribute.name, url: url)
                    }
                }
                .prefersTextualRepresentation()
                Divider()
                NonWrappingText(license.text, fontSize: LayoutMetrics.fontSize, maxWidth: LayoutMetrics.maximumWidth)
            }
            .labeledContentStyle(.attribute)
            .frame(width: LayoutMetrics.maximumWidth)
            .padding()
        }
        .background(Color.textBackgroundColor)
        .navigationTitle(license.name)
        .frame(minHeight: LayoutMetrics.minimumHeight)
    }

}

#endif
