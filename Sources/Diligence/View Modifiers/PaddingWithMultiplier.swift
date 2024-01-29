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

struct PaddingWithMultiplier: ViewModifier {

    var edges: Edge.Set
    var multiplier: Int

    init(_ edges: Edge.Set, multiplier: Int) {
        self.edges = edges
        self.multiplier = multiplier
    }

    func body(content: Content) -> some View {
        if multiplier <= 1 {
            content
                .padding(edges)
        } else {
            content
                .modifier(PaddingWithMultiplier(edges, multiplier: multiplier - 1))
                .padding(edges)
        }
    }

}

extension View {

    func padding(_ edges: Edge.Set, multiplier: Int) -> some View {
        return modifier(PaddingWithMultiplier(edges, multiplier: multiplier))
    }

}
