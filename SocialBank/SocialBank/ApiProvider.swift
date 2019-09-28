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
    
    typealias AnswerResult = Result<Void, NError>
    func postAnswer(request: AnswerRequest, iniciativeId: String) -> Observable<AnswerResult>  {
        return provider.rx.request(.answer(request, iniciativeId: iniciativeId))
            .asObservable()
            .map { _ in .success(()) }
            .catchErrorJustReturn(.failure(.iniciativeList))
    }
    
    typealias IniciativeFullResult = Result<IniciativeFullResponse, NError>
    func getIniciativeFull(request: IniciativeFullRequest) -> Observable<IniciativeFullResult>  {
//        let mock = JSON(parseJSON: """
//        { "questions": [
//
//        { "id": "1",
//        "items": [
//        {"title": "T1byevsiyvuebsovubdohjbsovjhbeouvboayewbvojhabdjohvboahdbvohbao ufiuaeoi ", "id": 1},
//        {"title": "T2", "id": 2},
//        {"title": "T3", "id": 3}
//        ]
//        },
//        { "id": "2",
//        "items": [
//        {"title": "T1", "id": 1},
//        {"title": "T2", "id": 2},
//        {"title": "T3", "id": 3}
//        ]
//        }]}
//        """)
//        print(mock)
//        return Observable.just(.success(try! IniciativeFullResponse(json: mock)))
        return provider.rx.request(.iniciativeFull(request))
            .asObservable()
            .mapObject(type: IniciativeFullResponse.self)
            .map { .success($0) }
            .catchErrorJustReturn(.failure(.iniciativeFull))
    }
}
