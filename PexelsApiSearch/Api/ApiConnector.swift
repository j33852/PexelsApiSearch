//
//  ApiConnector.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class ApiConnector {
    static func searchPhotos(keyword: String, page: Int) -> Observable<SearchResult> {
        RxAlamofire.request(ApiUrl.searchPhotos(keyword: keyword, page: page)).responseJSON()
            .catchError { err in
                return Observable.empty()
            }.map { response in
                guard let data = response.data else {
                    return SearchResult()
                }
                return try JSONDecoder().decode(SearchResult.self, from: data)
            }
    }
}

enum ApiUrl: URLRequestConvertible {
    static let BASE_URL = "https://api.pexels.com/v1"
    static let PEXEL_API_KEY = "Po3hsAaLkFaWwA1GSJZU8i5EXEh7FJb3fAbdGK9mkXZxxqjLc8wYAHVv"

    case searchPhotos(keyword: String, page: Int)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .searchPhotos:
            return "/search"
        }
    }

    var headers: HTTPHeaders {
        return HTTPHeaders(["Authorization": ApiUrl.PEXEL_API_KEY])
    }
    var parameters: Parameters {
        switch self {
            case .searchPhotos(let keyword, let page):
                return ["query": keyword,
                        "per_page": 20,
                        "page": page
                ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try ApiUrl.BASE_URL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        switch self {
            case .searchPhotos:
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }

}

