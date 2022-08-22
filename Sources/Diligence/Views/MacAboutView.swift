// Copyright (c) 2018-2022 InSeven Limited
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

#if compiler(>=5.7) && os(macOS)

@available(macOS 13, *)
struct MacAboutView: View {

    @Environment(\.openURL) private var openURL
    @Environment(\.openWindow) private var openWindow

    private let repository: String?
    private let actions: [Action]
    private let acknowledgements: [Acknowledgements]
    private let licenses: [License]

    init(repository: String? = nil, actions: [Action], acknowledgements: [Acknowledgements], licenses: [License]) {
        self.repository = repository
        self.actions = actions
        self.acknowledgements = acknowledgements
        self.licenses = licenses
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    MacIcon("Icon")
                    Spacer()
                }
                .padding()
                .padding([.horizontal])
                ScrollView {
                    VStack {
                        HStack {
                            ApplicationNameTitle()
                            Spacer()
                        }
                        .padding(.bottom, 2.0)
                        if !acknowledgements.isEmpty {
                            ForEach(acknowledgements) { acknowledgements in
                                MacAboutSection(acknowledgements.title) {
                                    ForEach(acknowledgements.credits) { credit in
                                        if let url = credit.url {
                                            Text(credit.name)
                                                .hyperlink {
                                                    openURL(url)
                                                }
                                        } else {
                                            Text(credit.name)
                                        }
                                    }
                                }
                            }
                        }
                        if !licenses.isEmpty {
                            MacAboutSection("Licenses") {
                                ForEach(licenses) { license in
                                    Text(license.name)
                                        .hyperlink {
                                            openWindow(id: MacLicenseWindowGroup.windowID, value: license.id)
                                        }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .textSelection(.enabled)
            }
            Divider()
            HStack {
                Text("Version \(Bundle.main.version ?? "") (\(Bundle.main.build ?? ""))")
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
                if let repository = repository,
                   let url = Bundle.main.commitUrl(for: repository),
                   let commit = Bundle.main.commit {
                    Text(commit)
                        .hyperlink {
                            openURL(url)
                        }
                }
                Spacer()
                ForEach(actions) { action in
                    Button(action.title) {
                        openURL(action.url)
                    }
                }
            }
            .padding()
        }
    }

}

#endif
