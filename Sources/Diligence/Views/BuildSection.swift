// Copyright (c) 2018-2021 Jason Morley, Tom Sutcliffe
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

public struct BuildSection<Header: View>: View {

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    var project: String
    var header: Header?

    private var date: String? {
        guard let date = UIApplication.shared.utcBuildDate else {
            return nil
        }
        return dateFormatter.string(from: date)
    }

    public init(_ project: String, @ViewBuilder header: () -> Header?) {
        self.project = project
        self.header = header()
    }

    public var body: some View {
        Section(header: header) {
            ValueRow(text: "Version", detailText: UIApplication.shared.version ?? "")
            ValueRow(text: "Build", detailText: UIApplication.shared.build ?? "")
            ValueRow(text: "Date", detailText: date ?? "")
            Button {
                guard let url = UIApplication.shared.commitUrl(for: project) else {
                    return
                }
                UIApplication.shared.open(url)
            } label: {
                ValueRow(text: "Commit", detailText: UIApplication.shared.commit ?? "")
            }
        }
    }

}


extension BuildSection where Header == EmptyView {

    public init(_ project: String) {
        self.init(project, header: { return nil })
    }

}
