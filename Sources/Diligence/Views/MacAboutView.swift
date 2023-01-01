// Copyright (c) 2018-2023 InSeven Limited
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
public struct MacAboutView: View {

    private struct LayoutMetrics {
        static let width = 600.0
        static let height = 360.0
    }

    @Environment(\.openURL) private var openURL
    @Environment(\.openWindow) private var openWindow

    private let repository: String?
    private let copyright: String?
    private let actions: [Action]
    private let acknowledgements: [Acknowledgements]
    private let licenses: [License]
    private let usesAppKit: Bool

    func openLicenseWindow(_ license: License) {

        // Check to see if the window is already open and activate it if it is.
        for window in NSApplication.shared.windows {
            guard let licenseWindow = window as? NSLicenseWindow else {
                continue
            }
            if licenseWindow.license.id == license.id {
                window.makeKeyAndOrderFront(nil)
                return
            }
        }

        // If not, create a new license window.
        let window = NSLicenseWindow(license: license)
        window.makeKeyAndOrderFront(nil)
    }

    init(repository: String? = nil,
         copyright: String? = nil,
         actions: [Action],
         acknowledgements: [Acknowledgements],
         licenses: [License],
         usesAppKit: Bool = false) {
        self.repository = repository
        self.copyright = copyright
        self.actions = actions
        self.acknowledgements = acknowledgements
        self.licenses = licenses.includingDiligenceLicense().sorted {
            $0.name.localizedCompare($1.name) == .orderedAscending
        }
        self.usesAppKit = usesAppKit
    }

    public init(repository: String? = nil,
                copyright: String? = nil,
                @ActionsBuilder actions: () -> [Action],
                @AcknowledgementsBuilder acknowledgements: () -> [Acknowledgements] = { [] },
                @LicensesBuilder licenses: () -> [License] = { [] },
                usesAppKit: Bool = false) {
        self.init(repository: repository,
                  copyright: copyright,
                  actions: actions(),
                  acknowledgements: acknowledgements(),
                  licenses: licenses(),
                  usesAppKit: usesAppKit)
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack {
                    MacIcon("Icon")
                    Spacer()
                }
                .padding(.all, multiplier: 2)
                ScrollView {
                    VStack {
                        VStack(spacing: 8.0) {
                            ApplicationNameTitle()
                                .horizontalSpace(.trailing)
                            if let copyright = copyright {
                                Text(copyright)
                                    .horizontalSpace(.trailing)
                            }
                        }
                        .padding(.bottom)
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
                                            if usesAppKit {
                                                openLicenseWindow(license)
                                            } else {
                                                openWindow(id: MacLicenseWindowGroup.windowID, value: license.id)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.top, multiplier: 2)
                    .padding(.bottom)
                }
                .textSelection(.enabled)
            }
            .background(Color.textBackgroundColor)
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
                } else if let commit = Bundle.main.commit {
                    Text(commit)
                        .foregroundColor(.secondary)
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
        .frame(width: LayoutMetrics.width, height: LayoutMetrics.height)
    }

}

#endif
