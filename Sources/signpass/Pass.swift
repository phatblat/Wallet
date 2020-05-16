import ArgumentParser

struct Pass: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Sign or verify an Apple Wallet pass.",
        subcommands: [Sign.self, Verify.self])
}
