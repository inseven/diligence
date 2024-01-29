// Copyright (c) 2018-2024 InSeven Limited
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

public struct Icon: View {

    struct LayoutMetrics {
        static let size = 120.0
        static let cornerRadiusRatio = 0.1754
    }

    private let name: String

    public init(_ name: String) {
        self.name = name
    }

    public var body: some View {
        GeometryReader { geometry in
            Image(name)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.width * LayoutMetrics.cornerRadiusRatio,
                                            style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: geometry.size.width * LayoutMetrics.cornerRadiusRatio,
                                          style: .continuous)
                    .stroke(.primary, lineWidth: 1)
                    .opacity(0.2))
        }
        .aspectRatio(1.0, contentMode: .fit)
        .frame(width: LayoutMetrics.size, height: LayoutMetrics.size)
    }

}
