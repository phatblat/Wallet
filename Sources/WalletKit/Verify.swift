import ArgumentParser
import Foundation

extension Pass {
    struct Verify: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Unzip and verify a signed pass's signature and manifest.",
            discussion: "This DOES NOT validate pass content."
        )

        @Option(name: NameSpecification([
            NameSpecification.Element.short,
            NameSpecification.Element.customLong("path")]),
                help: "Path to signed .pkpass file to verify.")
        var packagePath: String?

        var packageUrl: URL?

        mutating func validate() throws {

            guard let path = packagePath else {
                throw ValidationError("Please provide path to the pass package.")
            }

            debugPrint("path: \(path)")
        }

        func run() throws {
            let currentDir = URL(fileURLWithPath: ".", isDirectory: true)
            debugPrint("currentDir: \(currentDir)")

            guard let path = packagePath else {
                throw ValidationError("Please provide path to the pass package.")
            }

            let passUrl = URL(fileURLWithPath: path, isDirectory: false, relativeTo: currentDir)
            debugPrint("passUrl: \(passUrl)")

            // get a temporary place to unpack the pass
            let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
            let tempPath = tempDir.appendingPathComponent(passUrl.lastPathComponent).path

            // unzip the pass there
            let process = Process()
            process.launchPath = "/usr/bin/unzip"
            process.arguments = ["-q", "-o", passUrl.path, "-d", tempPath]
            process.launch()
            process.waitUntilExit()

            guard !process.isRunning else { fatalError("unzip command is still running") }

            switch process.terminationStatus {
            case 0:
                debugPrint("unzip completed in \(tempPath)")
                debugPrint("extracted pass contents:")
                let contents = try FileManager.default.contentsOfDirectory(atPath: tempPath)
                contents.forEach { file in
                    debugPrint(" - \(file)")
                }
            default:
                print("Error unzipping pass: \(process.terminationStatus) \(process.terminationReason)")
            }
        }
    }
}
