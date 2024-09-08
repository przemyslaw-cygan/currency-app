import ComposableArchitecture
import CurrencyAPI
import CurrencyAPIData
import CurrencyAPILive
import CurrencyAPIStub
import Foundation

extension CurrencyAPI.Client: DependencyKey {
    public static let liveValue = Client.stub()
    //    public static let liveValue: CurrencyAPI.Client = {
    //        let urlSessionConfiguration = URLSessionConfiguration.default
    //        urlSessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
    //
    //        let cacheQueryItem = URLQueryItem(
    //            name: "cache_timestamp",
    //            value: "\(Date.now.roundedToHours.timeIntervalSince1970)"
    //        )
    //
    //        return CurrencyAPI.Client.live(
    //            baseURL: "https://api.currencyapi.com",
    //            apiKey: "<API_KEY>",
    //            session: URLSession(configuration: urlSessionConfiguration),
    //            urlComponentsModifier: {
    //                $0.queryItems = ($0.queryItems ?? []) + [cacheQueryItem]
    //            }
    //        )
    //    }()
}

public extension DependencyValues {
    var currencyAPIClient: CurrencyAPI.Client {
        get { self[CurrencyAPI.Client.self] }
        set { self[CurrencyAPI.Client.self] = newValue }
    }
}
