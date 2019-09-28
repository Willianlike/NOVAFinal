//
//  ApiProvider.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift

class ApiProvider {
    private let provider: MoyaProvider<API>

    //let moyaPlugins: [Moya.PluginType] = [MoyaCacheablePlugin()]
    let moyaPlugins: [Moya.PluginType] = [NetworkLoggerPlugin(verbose: true, cURL: true)]
    //let moyaPlugins: [Moya.PluginType] = [NetworkLoggerPlugin(verbose: false, cURL: true), MoyaCacheablePlugin()]
    
    static let shared = ApiProvider()

    private init() {
        self.provider = MoyaProvider<API>(
            endpointClosure: { (target: API) -> Endpoint in
                return Endpoint(url: target.baseURL.absoluteString,
                                sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)}
            , manager: APISessionManager.sharedManager
            , plugins: moyaPlugins)
    }
    
    typealias AuthResult = Result<LoginResponse, NError>
    func auth(request: LoginRequest) -> Observable<AuthResult>  {
        return provider.rx.request(.login(request))
            .asObservable()
            .mapObject(type: LoginResponse.self)
            .map { .success($0) }
            .catchErrorJustReturn(.failure(.auth))
    }
    
    typealias IniciativeListResult = Result<IniciativeListResponse, NError>
    func getIniciativeList(request: IniciativeListRequest) -> Observable<IniciativeListResult>  {
        return provider.rx.request(.iniciativeList(request))
            .asObservable()
            .mapObject(type: IniciativeListResponse.self)
            .map { .success($0) }
            .catchErrorJustReturn(.failure(.iniciativeList))
    }
}
