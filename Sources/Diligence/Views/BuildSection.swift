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

import SwiftUI

public struct BuildSection<Header: View>: View {

    @Environment(\.openURL) private var openURL

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    private let project: String?
    private let bundle: Bundle
    private let header: Header?

    private var date: String? {
        guard let date = bundle.utcBuildDate else {
            return nil
        }
        return dateFormatter.string(from: date)
    }

    public init(_ project: String? = nil, bundle: Bundle = Bundle.main, @ViewBuilder header: () -> Header?) {
        self.project = project
        self.bundle = bundle
        self.header = header()
    }

    public var body: some View {
        Section(header: header) {
            LabeledContent("Version") {
                Text(bundle.version ?? "")
                    .textSelection(.enabled)
            }
            LabeledContent("Build") {
                Text(bundle.build ?? "")
                    .textSelection(.enabled)
            }
            if let date = date {
                LabeledContent("Date") {
                    Text(date)
                        .textSelection(.enabled)
                }
            }
            if let commit = bundle.commit {
                if let project = project {
                   let url = bundle.commitUrl(for: project)
                    Button {
                        if let url {
                            openURL(url)
                        }
                    } label: {
                        HStack {
                            Text("Commit")
                                .foregroundColor(.primary)
                            Spacer()
                            if url != nil {
                                Text(commit)
                                    .prefersMonospaced()
                                    .foregroundColor(.accentColor)
                                    .prefersLinkForegroundStyle()
                                    .textSelection(.enabled)
                            } else {
                                Text(commit)
                                    .prefersMonospaced()
                            }
                        }
                    }
                } else {
                    LabeledContent("Commit") {
                        Text(commit)
                            .textSelection(.enabled)
                    }
                }
            }
        }
    }

}

extension BuildSection where Header == EmptyView {

    public init(_ project: String? = nil, commitUrl: URL? = nil) {
        self.init(project, header: { return nil })
    }

}
