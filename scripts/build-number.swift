#!/usr/bin/env swift

import Foundation

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    return output
}

let now = Date()
let dateFormatter = DateFormatter()
dateFormatter.locale = Locale(identifier: "en_US_POSIX")
dateFormatter.dateFormat = "yyMMddHHmm"
dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
let dateValue = dateFormatter.string(from: now)

let sha = shell("git rev-parse --short=6 HEAD").trimmingCharacters(in: .whitespacesAndNewlines)
let shaValue = Int(sha, radix: 16)!

let build = String(format: "%@%08d", dateValue, shaValue)
print(build)
