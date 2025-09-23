// Copyright (c) 2018-2025 Jason Morley
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

#if os(iOS)

import SwiftUI

struct TableViewRowButtonStyle: ButtonStyle {

    struct LayoutMetrics {

        static let minHeight: CGFloat = {
            if #available(iOS 26, *) {
                return 56.0
            } else {
                return 44.0
            }
        }()

        static let horizontalPadding: CGFloat = {
            if #available(iOS 26, *) {
                return 28.0
            } else {
                return 20.0
            }
        }()

        static let cornerRadius: CGFloat = {
            if #available(iOS 26, *) {
                return 25.0
            } else {
                return 10.0
            }
        }()
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.accentColor)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, LayoutMetrics.horizontalPadding)
            .frame(minHeight: LayoutMetrics.minHeight)
            .background(configuration.isPressed ? Color(uiColor: .systemGray4) : Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: LayoutMetrics.cornerRadius, style: .circular))
    }

}

extension ButtonStyle where Self == TableViewRowButtonStyle {

    static var tableViewRow: TableViewRowButtonStyle {
        return TableViewRowButtonStyle()
    }

}

#endif
