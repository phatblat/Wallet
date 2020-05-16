import ArgumentParser

struct Random: ParsableCommand {
    @Argument() var highValue: Int

    func run() {
        print(Int.random(in: 1...highValue))
    }
}

Random.main()
