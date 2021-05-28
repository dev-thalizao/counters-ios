[![CI](https://github.com/dev-thalizao/counters-ios/actions/workflows/ci.yml/badge.svg)](https://github.com/dev-thalizao/counters-ios/actions/workflows/ci.yml)
![Xcode](https://img.shields.io/badge/Xcode-12.4-blue.svg?style=flat)
[![Swift 5.3.2](https://img.shields.io/badge/Swift-5.3.2-orange.svg?style=flat)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-13.0-red?style=flat)

# Counters, the app who store your counters 🤖

The architecture was built using the concepts of Clean Architecture and the SOLID principles. The modularization was composed by:
- [CounterCore](./CounterCore/Sources/CounterCore): Domain layer composed by counter model and all use cases.
- [CounterAPI](./CounterCore/Sources/CounterAPI): Data layer composed by remote implementation of domain use cases. 
- [CounterStore](./CounterCore/Sources/CounterCore): Data layer composed by local implementation of domain use cases.
- [CounterPresentation](./CounterCore/Sources/CounterPresentation): Presentation layer composed by the presenters and view models.
- [CounterUI](./CounterCore/Sources/CounterUI): UIKit interfaces that interact with presentation layer.
- [CounterTests](./CounterCore/Sources/CounterTests): Add extra behaviours specific for unit tests.
- [CounterApp](./Counter/Counter): The main module, that create features and inject the dependencies, control the navigation flow, add new behaviours trough decorators and adapters.

## Features

- Load counters;
- Cache Counters;
- Create Counter;
- Increment Counters;
- Decrement Counters;
- Search Counters;
- Erase Counters;
- Share Counters;

## Non-functional features

- Clean Architecture
- SOLID Principles
- Unit Tests using TDD
- Modularity using Swift Package
- Design Patterns (Strategy, Proxy, Decorator and Adapter)
- UITableViewDiffableDataSource
- View Code
- Dark Mode
- HTTP requests
- Error Handling
- CI using GitHub Actions
- CoreData