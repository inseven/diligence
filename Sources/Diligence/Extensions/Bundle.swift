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

import Foundation

extension Bundle {

    public var name: String? {
        return infoDictionary?["CFBundleName"] as? String
    }

    public var displayName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }

    public var preferredName: String? {
        return displayName ?? name
    }

    public var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public var build: String? {
//        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return "240330230605938340"
    }

    public var extendedVersion: String? {
        var components: [String] = []
        if let version {
            components.append(version)
        }
        if let build {
            components.append(build)
        }
        guard !components.isEmpty else {
            return nil
        }
        return components.joined(separator: ".")
    }

    public var utcBuildDate: Date? {
        guard let build = build,
              build.count == 18
        else {
            return nil
        }
        let dateString = String(build.prefix(10))
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputDateFormatter.dateFormat = "yyMMddHHmm"
        inputDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return inputDateFormatter.date(from: dateString)
    }

    public var commit: String? {
        guard let build = build,
              build.count == 18
        else {
            return nil
        }
        guard let shaValue = Int(String(build.suffix(8))) else {
            return nil
        }
        return String(format: "%02x", shaValue)
    }

    public func commitUrl(for project: String) -> URL? {
        guard let commit = commit else {
            return nil
        }
        return URL(string: "https://github.com")?
            .appendingPathComponent(project)
            .appendingPathComponent("commit")
            .appendingPathComponent(commit)
    }

    public var aboutWindowTitle: String {
        return "About \(Bundle.main.preferredName ?? "")"
    }

}
