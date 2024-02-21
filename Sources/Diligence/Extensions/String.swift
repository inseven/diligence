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

struct StringLayoutMetrics {

    let size: CGSize
    let fontSize: CGFloat

}

extension String {

    init?(contentsOfBundleFile filename: String, bundle: Bundle = Bundle.main) {
        guard let path = bundle.path(forResource: filename, ofType: nil) else {
            return nil
        }
        try? self.init(contentsOfFile: path)
    }

    func metrics(forFontSize fontSize: CGFloat) -> StringLayoutMetrics {
        let font = NativeFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        let size = self.size(withAttributes: [.font : font])
        return StringLayoutMetrics(size: size, fontSize: fontSize)
    }

    func fontSize(thatFits width: CGFloat,
                  preferredFontSize: CGFloat,
                  minimumFontSize: CGFloat) -> StringLayoutMetrics {
        precondition(minimumFontSize > 0)
        precondition(minimumFontSize < width)

        // Check to see if the preferred font size fits; return it if it does.
        let idealSize = metrics(forFontSize: preferredFontSize)
        if idealSize.size.width <= width {
            return idealSize
        }

        // Calculate the scale and return the preferred size.
        let scale = width / idealSize.size.width
        let fontSize = max(preferredFontSize * scale, minimumFontSize)
        return metrics(forFontSize: fontSize)
    }

}
