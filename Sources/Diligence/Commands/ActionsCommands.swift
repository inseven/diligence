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

@available(macOS 13, *, iOS 16, *)
public struct ActionsCommands: Commands {
    
    public enum Placement {
        case before(CommandGroupPlacement)
        case after(CommandGroupPlacement)
        case replacing(CommandGroupPlacement)
    }
    
    @Environment(\.openURL) private var openURL
    
    let placement: Placement
    let actions: [Action]
    
    public init(placement: Placement = .replacing(.help), @ActionsBuilder actions: () -> [Action]) {
        self.placement = placement
        self.actions = actions()
    }

    public init(_ contents: Contents, placement: Placement = .replacing(.help)) {
        self.placement = placement
        self.actions = contents.actions
    }

    var buttons: some View {
        ForEach(actions) { action in
            Button {
                openURL(action.url)
            } label: {
                Label(action.title, systemImage: action.url.scheme == "mailto" ? "envelope" : "globe")
            }
        }
    }
    
    public var body: some Commands {
        switch placement {
        case .before(let before):
            CommandGroup(before: before) {
                buttons
                Divider()
            }
        case .after(let after):
            CommandGroup(after: after) {
                Divider()
                buttons
            }
        case .replacing(let replacing):
            CommandGroup(replacing: replacing) {
                buttons
            }
        }
    }
    
}
