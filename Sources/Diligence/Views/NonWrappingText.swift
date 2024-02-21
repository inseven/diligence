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

struct NonWrappingText: View {

    let text: String
    let layout: StringLayoutMetrics
    let maxWidth: CGFloat

    init(_ text: String, fontSize: CGFloat, minimumFontSize: CGFloat? = nil, maxWidth: CGFloat = .infinity) {
        self.text = text
        self.maxWidth = maxWidth

        if let minimumFontSize {
            self.layout = text.fontSize(thatFits: maxWidth,
                                          preferredFontSize: fontSize,
                                          minimumFontSize: minimumFontSize)
        } else {
            self.layout = text.metrics(forFontSize: fontSize)
        }
    }

    var body: some View {
        Text(text)
            .font(.system(size: layout.fontSize, design: .monospaced))
            .frame(width: min(layout.size.width, maxWidth))
            .textSelection(.enabled)
    }

}
