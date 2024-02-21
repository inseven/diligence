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

import Licensable

#if compiler(>=5.7) && os(iOS)

public struct PhoneAboutView: View {

    private struct LayoutMetrics {
        static let headerVisibilityThreshold = 30.0
    }

    @Environment(\.presentationMode) var presentationMode

    private let repository: String?
    private let copyright: String?
    private let actions: [Action]
    private let acknowledgements: [Acknowledgements]
    private let licenseGroups: [LicenseGroup]

    @State var isHeaderVisible: Bool = true

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
    }

    public init(repository: String? = nil,
                copyright: String? = nil,
                @ActionsBuilder actions: () -> [Action] = { [] },
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

    public init(_ contents: Contents) {
        self.repository = contents.repository
        self.copyright = contents.copyright
        self.actions = contents.actions
        self.acknowledgements = contents.acknowledgements
        self.licenseGroups = contents.licenseGroups
    }

    public var body: some View {
        NavigationView {
            Form {
                HeaderSection {
                    VStack {
                        Icon("Icon")
                        ApplicationNameTitle()
                    }
                    .opacity(isHeaderVisible ? 1.0 : 0.0)
                    .isVisibleInScrollView($isHeaderVisible, threshold: LayoutMetrics.headerVisibilityThreshold)

                    if let copyright = copyright {
                        Text(copyright)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                    }
                }
                BuildSection(repository)
                ActionSection(actions)
                ForEach(acknowledgements.filter { !$0.credits.isEmpty }) { acknowledgement in
                    CreditSection(acknowledgement.title, acknowledgement.credits)
                }
                ForEach(licenseGroups) { licenseGroup in
                    LicenseSection(licenseGroup.title, licenseGroup.licenses)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(Bundle.main.preferredName ?? "")
                            .fontWeight(.bold)
                            .opacity(isHeaderVisible ? 0.0 : 1.0)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }

            }
        }
        .navigationViewStyle(.stack)
    }

}

#endif
