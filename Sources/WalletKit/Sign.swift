import ArgumentParser

extension Pass {
    struct Sign: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Sign a pass package."
        )

        @Option(name: NameSpecification([
            NameSpecification.Element.short,
            NameSpecification.Element.customLong("path")]),
                help: "Path to pass package.")
        var packagePath: String?

        @Option(name: NameSpecification([
            NameSpecification.Element.short,
            NameSpecification.Element.customLong("output")]),
                help: "Output path.")
        var outputPath: String?

        @Option(name: .shortAndLong, help: "Certificate suffix.")
        var certificateSuffix: String?

        func run() {}
    }
}
