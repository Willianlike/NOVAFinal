//
//  RxMoya.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import Foundation
import RxSwift
//#if !COCOAPODS
import Moya
import SwiftyJSON
//#endif

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {

    /// Designated request-making method.
    ///
    /// - Parameters:
    ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single response object.
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    /// Designated request-making method with progress.
    func requestWithProgress(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
            return { progress in
                observer.onNext(progress)
            }
        }

        let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: progressBlock(observer)) { result in
                switch result {
                case .success:
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }

        // Accumulate all progress and combine them when the result comes
        return response.scan(ProgressResponse()) { last, progress in
            let progressObject = progress.progressObject ?? last.progressObject
            let response = progress.response ?? last.response
            return ProgressResponse(progress: progressObject, response: response)
        }
    }
}



















/// Extension for processing raw NSData generated by network access.
extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    /// Filters out responses that don't fall within the given closed range, generating errors when others are encountered.
    public func filter<R: RangeExpression>(statusCodes: R) -> Single<ElementType> where R.Bound == Int {
        return flatMap { .just(try $0.filter(statusCodes: statusCodes)) }
    }

    /// Filters out responses that have the specified `statusCode`.
    public func filter(statusCode: Int) -> Single<ElementType> {
        return flatMap { .just(try $0.filter(statusCode: statusCode)) }
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 299.
    public func filterSuccessfulStatusCodes() -> Single<ElementType> {
        return flatMap { .just(try $0.filterSuccessfulStatusCodes()) }
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 399
    public func filterSuccessfulStatusAndRedirectCodes() -> Single<ElementType> {
        return flatMap { .just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }

    /// Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    public func mapImage() -> Single<Image> {
        return flatMap { .just(try $0.mapImage()) }
    }

    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapJSON(failsOnEmptyData: Bool = true) -> Single<Any> {
        return flatMap { .just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }

    /// Maps received data at key path into a String. If the conversion fails, the signal errors.
    public func mapString(atKeyPath keyPath: String? = nil) -> Single<String> {
        return flatMap { .just(try $0.mapString(atKeyPath: keyPath)) }
    }

    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    public func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap { .just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}























/// Extension for processing raw NSData generated by network access.
extension ObservableType where E == Response {

    /// Filters out responses that don't fall within the given range, generating errors when others are encountered.
    public func filter<R: RangeExpression>(statusCodes: R) -> Observable<E> where R.Bound == Int {
        return flatMap { Observable.just(try $0.filter(statusCodes: statusCodes)) }
    }

    /// Filters out responses that has the specified `statusCode`.
    public func filter(statusCode: Int) -> Observable<E> {
        return flatMap { Observable.just(try $0.filter(statusCode: statusCode)) }
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 299.
    public func filterSuccessfulStatusCodes() -> Observable<E> {
        return flatMap { Observable.just(try $0.filterSuccessfulStatusCodes()) }
    }

    /// Filters out responses where `statusCode` falls within the range 200 - 399
    public func filterSuccessfulStatusAndRedirectCodes() -> Observable<E> {
        return flatMap { Observable.just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }

    /// Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    public func mapImage() -> Observable<Image> {
        return flatMap { Observable.just(try $0.mapImage()) }
    }

    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapJSON(failsOnEmptyData: Bool = true) -> Observable<Any> {
        return flatMap { Observable.just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }

    /// Maps received data at key path into a String. If the conversion fails, the signal errors.
    public func mapString(atKeyPath keyPath: String? = nil) -> Observable<String> {
        return flatMap { Observable.just(try $0.mapString(atKeyPath: keyPath)) }
    }

    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    public func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Observable<D> {
        return flatMap { Observable.just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}

extension ObservableType where E == ProgressResponse {

    /**
     Filter completed progress response and maps to actual response
     - returns: response associated with ProgressResponse object
     */
    public func filterCompleted() -> Observable<Response> {
        return self
            .filter { $0.completed }
            .flatMap { progress -> Observable<Response> in
                // Just a formatlity to satisfy the compiler (completed progresses have responses).
                switch progress.response {
                case .some(let response): return .just(response)
                case .none: return .empty()
                }
            }
    }

    /**
     Filter progress events of current ProgressResponse
     - returns: observable of progress events
     */
    public func filterProgress() -> Observable<Double> {
        return self.filter { !$0.completed }.map { $0.progress }
    }
}











/// Extension for processing Responses into Mappable objects through ObjectMapper
extension ObservableType where E == Response {
    
    /** Maps data received from the signal into an object which implements the
     ALSwiftyJSONAble protocol.
     If the conversion fails, the signal errors.
     
     - Parameter type: Type of the mappable object
     
     - Returns: An Observable containing mapped object
     **/
    func mapObject<T: JSONDecodable>(type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type: T.self))
        }
    }
    
    /** Maps data received from the signal into an object which implements the
     ALSwiftyJSONAble protocol.
     If the conversion fails, the signal errors.
     
     - Parameter type: Type of the mappable object
     
     - Returns: An Observable containing mapped object
     **/
    func mapObjectSafe<T: JSONDecodable>(type: T.Type) -> Observable<T?> {
        return flatMap { response -> Observable<T?> in
            return Observable.just(response.mapObjectSafe(type: T.self))
        }
    }

    /** Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol.
        If the conversion fails, the signal errors.

        - Parameter type: Type of element of mappable array

        - Returns: An Observable containing array of specified type
    **/
    func mapArray<T: JSONDecodable>(type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type: T.self))
        }
    }
}









extension Response {
    func mapObject<T: JSONDecodable>(type: T.Type) throws -> T {
        let object = try mapJSON()
        let json = JSON(object)
        return try T(json: json)
    }
    func mapObjectSafe<T: JSONDecodable>(type: T.Type) -> T? {
        if let object = try? mapJSON() {
            let json = JSON(object)
            return try? T(json: json)
        } else {
            return nil
        }
    }

    func mapArray<T: JSONDecodable>(type: T.Type) throws -> [T] {
        let object = try mapJSON()
        let json = JSON(object)
        guard let array = json.array else {
            throw MoyaError.jsonMapping(self)
        }

        return try array.compactMap { try T(json: $0) }
    }
}









enum JSONDecodeError: Error {
    case error
    case missingValue
    case wrongValueType(requested: String?)
    case invalidValue
    case message(String)
    
    var errorMessage: String? {
        switch self {
        case let .message(mes):
            return mes
        default:
            return nil
        }
    }
}

extension JSON {
    public func reqString() throws -> String {
        switch self.type {
        case .number:
            return self.numberValue.stringValue
        case .string:
            return self.stringValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "String")
        }
    }

    public func reqInt() throws -> Int {
        switch self.type {
        case .number:
            return self.intValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "Int")
        }
    }
    
    public func reqFloat() throws -> Float {
        switch self.type {
        case .number:
            return self.floatValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "Float")
        }
    }
    
    public func reqDouble() throws -> Double {
        switch self.type {
        case .number:
            return self.doubleValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "Double")
        }
    }

    public func reqArray() throws -> [JSON] {
        switch self.type {
        case .array:
            return self.arrayValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "Array")
        }
    }

    public func reqDictionary() throws -> [String : JSON] {
        switch self.type {
        case .dictionary:
            return self.dictionaryValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "Dictionary")
        }
    }

    public func reqURL() throws -> URL {
        switch self.type {
        case .string:
            if let url = self.url {
                return url
            } else {
                throw JSONDecodeError.wrongValueType(requested: "URL")
            }
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "URL")
        }
    }

    public func reqBool() throws -> Bool {
        switch self.type {
        case .bool:
            return self.boolValue
        case .null:
            throw JSONDecodeError.missingValue
        default:
            throw JSONDecodeError.wrongValueType(requested: "Bool")
        }
    }
}












protocol JSONDecodable {
    init(json: JSON) throws
}
