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

import Combine
import SwiftUI

#if os(iOS)

struct IsVisibleInScrollView: ViewModifier {

    class ViewModel: ObservableObject {
        @Published var offset: CGFloat = 0
        var cancellable: AnyCancellable?
    }

    @StateObject var viewModel = ViewModel()
    @Binding var isVisible: Bool
    private let threshold: CGFloat

    init(isVisible: Binding<Bool>, threshold: CGFloat) {
        _isVisible = isVisible
        self.threshold = threshold
    }

    func body(content: Content) -> some View {
        content
            .hookView { view in
                guard let scrollView = view.scrollView else {
                    return
                }
                viewModel.cancellable = scrollView
                    .publisher(for: \.contentOffset)
                    .receive(on: DispatchQueue.main)
                    .sink { contentOffset in
                        let scrollOffsetY = scrollView.safeAreaInsets.top + contentOffset.y
                        let relativeViewFrame = view.convert(view.frame, to: scrollView)
                        let viewPositionY = relativeViewFrame.maxY - scrollOffsetY
                        viewModel.offset = viewPositionY
                    }
            }
            .onChange(of: viewModel.offset) { offset in
                let isVisible = offset > threshold
                guard self.isVisible != isVisible else {
                    return
                }
                withAnimation {
                    self.isVisible = isVisible
                }
            }

    }

}

extension View {

    func isVisibleInScrollView(_ isVisible: Binding<Bool>, threshold: CGFloat = 0.0) -> some View {
        return modifier(IsVisibleInScrollView(isVisible: isVisible, threshold: threshold))
    }

}

#endif
