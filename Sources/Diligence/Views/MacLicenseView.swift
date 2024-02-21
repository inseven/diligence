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
struct FixedWidthTextView: View {

    let text: String
    let fontSize: CGFloat
    let size: CGSize

    init(_ text: String, fontSize: CGFloat) {
        self.text = text
        self.fontSize = fontSize
        let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        self.size = NSString(string: text).size(withAttributes: [.font : font])
    }

    var body: some View {
        Text(text)
            .font(.system(size: fontSize, design: .monospaced))
            .frame(width: size.width, height: size.height)
            .textSelection(.enabled)
    }

}

extension NSString {

    func fontSize(thatFits width: CGFloat, minimumFontSize: CGFloat = 1.0) -> CGFloat {
        precondition(minimumFontSize > 0)
        precondition(minimumFontSize < width)
        print("width = \(width)")
        // TODO: Some sort of binary search to increment?
        var fontSize = 12.0
        while fontSize > 1.0 {
            let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
            let size = self.size(withAttributes: [.font : font])
            if size.width <= width {
                print("fontSize = \(fontSize)")
                return fontSize
            }
            fontSize -= 1.0
        }
        return fontSize
    }

}

@available(macOS 13, *)
struct ScalingTextView: View {

    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        GeometryReader { geometry in
            let fontSize = (text as NSString).fontSize(thatFits: geometry.size.width)
            FixedWidthTextView(text, fontSize: fontSize)
        }
    }

}

@available(macOS 13, *)
struct MacLicenseView: View {

    private struct LayoutMetrics {
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
                FixedWidthTextView(license.text, fontSize: 12)
            }
            .labeledContentStyle(.attribute)
            .padding()
        }
        .background(Color.textBackgroundColor)
        .navigationTitle(license.name)
        .fixedSize(horizontal: true, vertical: false)
        .frame(minHeight: LayoutMetrics.minimumHeight)
    }

}

#endif
