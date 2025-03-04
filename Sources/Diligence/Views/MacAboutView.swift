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

import Licensable

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
    private let licenseGroups: [LicenseGroup]
    private let usesAppKit: Bool

    func openLicenseWindow(_ license: Licensable) {

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
        window.setContentSize(NSSize(width: MacLicenseWindowGroup.LayoutMetrics.width,
                                     height: MacLicenseWindowGroup.LayoutMetrics.width))
        window.makeKeyAndOrderFront(nil)
    }

    public init(repository: String? = nil,
                copyright: String? = nil,
                @ActionsBuilder actions: () -> [Action] = { [] },
                @AcknowledgementsBuilder acknowledgements: () -> [Acknowledgements] = { [] },
                @LicenseGroupsBuilder licenses: () -> [LicenseGroup] = { [ ] },
                usesAppKit: Bool = false) {
        self.repository = repository
        self.copyright = copyright
        self.actions = actions()
        self.acknowledgements = acknowledgements()
        self.licenseGroups = licenses()
        self.usesAppKit = usesAppKit
    }

    init(repository: String? = nil,
         copyright: String? = nil,
         actions: [Action],
         acknowledgements: [Acknowledgements],
         licenseGroups: [LicenseGroup],
         usesAppKit: Bool = false) {
        self.repository = repository
        self.copyright = copyright
        self.actions = actions
        self.acknowledgements = acknowledgements
        self.licenseGroups = licenseGroups
        self.usesAppKit = usesAppKit
    }

    public init(repository: String? = nil,
                copyright: String? = nil,
                @ActionsBuilder actions: () -> [Action],
                @AcknowledgementsBuilder acknowledgements: () -> [Acknowledgements] = { [] },
                @LicensesBuilder licenses: () -> [Licensable] = { [] },
                usesAppKit: Bool = false) {
        self.init(repository: repository,
                  copyright: copyright,
                  actions: actions,
                  acknowledgements: acknowledgements,
                  licenses: { LicenseGroup("Licenses", includeDiligenceLicense: true, licenses: licenses()) },
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
                        VStack(alignment: .leading, spacing: 8.0) {
                            ApplicationNameTitle()
                                .horizontalSpace(.trailing)
                            if let copyright = copyright {
                                Text(copyright)
                                    .horizontalSpace(.trailing)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.bottom)
                        MacAboutSection {
                            Grid {
                                GridRow {
                                    Text("Version")
                                        .gridColumnAlignment(.trailing)
                                        .font(.headline)
                                        .textSelection(.disabled)
                                    Text(Bundle.main.extendedVersion ?? "")
                                        .gridColumnAlignment(.leading)
                                }
                                if let date = Bundle.main.utcBuildDate {
                                    GridRow {
                                        Text("Date")
                                            .font(.headline)
                                            .textSelection(.disabled)
                                        Text(date, format: .dateTime)
                                    }
                                }
                                if let commit = Bundle.main.commit {
                                    GridRow {
                                        Text("Commit")
                                            .font(.headline)
                                            .textSelection(.disabled)
                                        if let repository = repository,
                                           let url = Bundle.main.commitUrl(for: repository) {
                                            Text(commit)
                                                .prefersMonospaced()
                                                .hyperlink {
                                                    openURL(url)
                                                }
                                        } else {
                                            Text(commit)
                                                .prefersMonospaced()
                                        }
                                    }
                                }
                            }
                        }
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
                        ForEach(licenseGroups) { licenseGroup in
                            MacAboutSection(licenseGroup.title) {
                                ForEach(licenseGroup.licenses) { license in
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
