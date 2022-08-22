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
public typealias About = AboutWindowGroup

@available(macOS 13, *)
public struct AboutWindowGroup: Scene {

    private let repository: String?
    private let copyright: String?
    private let actions: [Action]
    private let acknowledgements: [Acknowledgements]
    private let licenses: [License]

    public init(repository: String? = nil,
                copyright: String? = nil,
                @ActionsBuilder actions: () -> [Action],
                @AcknowledgementsBuilder acknowledgements: () -> [Acknowledgements] = { [] },
                @LicensesBuilder licenses: () -> [License] = { [] }) {
        self.repository = repository
        self.copyright = copyright
        self.actions = actions()
        self.acknowledgements = acknowledgements()
        self.licenses = licenses()
    }

    public var body: some Scene {
        MacAboutWindow(repository: repository,
                       copyright: copyright,
                       actions: actions,
                       acknowledgements: acknowledgements,
                       licenses: licenses)
        .commands {
            AboutCommands()
        }
        MacLicenseWindowGroup(licenses: licenses)
    }

}

#endif
