import ArgumentParser

public struct Pass: ParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "Sign or verify an Apple Wallet pass.",
        subcommands: [Sign.self, Verify.self])

    public init() {}
}
