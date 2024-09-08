import Common
import ComposableArchitecture
import CurrencyAPI
import CurrencyAPIData
import Foundation

@Reducer
public struct CurrenciesFeature: Sendable {
    @Dependency(\.currencyAPIClient) public var currencyAPIClient

    @ObservableState
    public struct State: Equatable {
        public var searchPhrase: String?

        public var items: [Currency]?
        public var filteredItems: [Currency]?

        @Presents public var destination: Destination.State?

        public init(
            searchPhrase: String? = nil,
            items: [Currency]? = nil,
            filteredItems: [Currency]? = nil,
            destination: Destination.State? = nil
        ) {
            self.searchPhrase = searchPhrase
            self.items = items
            self.filteredItems = filteredItems
            self.destination = destination
        }
    }

    public enum Action: ViewAction, Sendable {
        case loadItems
        case handleItems(Result<[Currency], Error>)

        case updateItems([Currency]?)
        case updateSearchPhrase(String?)

        case view(View)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum View: Sendable {
            case onLoad
            case onSearch(String?)
            case onSelect(Currency.ID)
        }
    }

    @Reducer(state: .equatable, action: .sendable)
    public enum Destination {
        case alert(AlertState<AlertAction>)
    }

    public enum AlertAction: Equatable, Sendable {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadItems:
                return .run { send in
                    await send(.handleItems(
                        Result {
                            let response = try await self.currencyAPIClient.currencies(CurrenciesRequest())
                            return Array(response.data.values)
                        }
                    ))
                }

            case .handleItems(.success(let items)):
                return .run { await $0(.updateItems(items)) }

            case .handleItems(.failure(let error)):
                state.destination = .alert(AlertState { TextState(error.localizedDescription) })
                return .none

            case .updateItems(let items):
                state.items = items?.sorted(by: { $0.order < $1.order })
                state.filteredItems = state.items?.filter { $0.match(state.searchPhrase) }
                return .none

            case .updateSearchPhrase(let searchPhrase):
                state.filteredItems = state.items?.filter { $0.match(searchPhrase) }
                state.searchPhrase = searchPhrase
                return .none

            case .view(.onLoad):
                return .run { await $0(.loadItems) }

            case .view(.onSearch(let searchPhrase)):
                return .run { await $0(.updateSearchPhrase(searchPhrase)) }

            case .view(.onSelect(let id)):
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    public init() {}
}
