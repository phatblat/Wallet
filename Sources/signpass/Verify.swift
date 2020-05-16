import ArgumentParser

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

        func run() {}
    }
}
