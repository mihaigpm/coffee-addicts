import ArgumentParser

enum Command {}

extension Command {
  struct Main: ParsableCommand {
    static var configuration: CommandConfiguration {
      .init(
        commandName: "coffeeaddicts",
        abstract: "A program to perform simple computations",
        version: "0.0.1",
        subcommands: [
            Command.CoffeeShopsFinder.self]
      )
    }
  }
}

Command.Main.main()
