//
//  IniciativeListingVM.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum IniciativeCell {
    case withImage(item: BankIniciativeModel)
    case withoutImage(item: BankIniciativeModel)
    
    init(model: BankIniciativeModel) {
//        if model.image.isNilOrEmpty {
            self = .withoutImage(item: model)
//        } else {
//            self = .withImage(item: model)
//        }
    }
    
    func getCellHeight(width: CGFloat) -> CGFloat {
        switch self {
        case .withImage:
            return IniciativeListingCellWithImage.getCellHeight()
        case let .withoutImage(item):
            return IniciativeListingCell.getCellHeight(width: width, item: item)
        }
    }
    
    func getIniciativeModel() -> BankIniciativeModel {
        switch self {
        case let .withImage(item):
            return item
        case let .withoutImage(item):
            return item
        }
    }
}

extension IniciativeCell: IdentifiableType, Equatable, Hashable {
    var identity: String {
        switch self {
        case let .withImage(item):
            return item.id
        case let .withoutImage(item):
            return item.id
        }
    }

    static func == (lhs: IniciativeCell, rhs: IniciativeCell) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}

class IniciativeListingVM {
    
    let provider: ApiProvider
    
    let cells = BehaviorRelay<[IniciativeCell]>(value: [])
    let filterSelected = BehaviorRelay<Int>(value: 0)
    let error = PublishSubject<NError>()
    let loading = BehaviorRelay<Bool>(value: true)
    
    let voteChanged = PublishSubject<VoteChanged>()
    
    let limit = 20
    
    let disposeBag = DisposeBag()
    
    init(provider: ApiProvider) {
        self.provider = provider
        loadItems()
        
        voteChanged.asObservable().withLatestFrom(cells) {($0, $1)}
            .map({ (voteChanged, cells) in
                var cells = cells
                for i in cells.indices {
                    let cell = cells[i]
                    var model = cell.getIniciativeModel()
                    if model.id == voteChanged.0 {
                        model.voteStatus = voteChanged.1
                        cells[i] = .withoutImage(item: model)
                    }
                }
                return cells
            }).bind(to: cells)
            .disposed(by: disposeBag)
        
        voteChanged.asObservable().flatMap {
            provider.vote(status: $0.1, id: $0.0)
            }.subscribe().disposed(by: disposeBag)
    }
    
    var loadItemsDispose = DisposeBag()
    func loadItems() {
        loading.accept(true)
        loadItemsDispose = DisposeBag()
        let initRequest = IniciativeListRequest(limit: limit, offset: cells.value.count)
        provider.getIniciativeList(request: initRequest)
            .subscribe(onNext: { [unowned self] result in
                self.resultResponse(result: result)
                self.loading.accept(false)
            }).disposed(by: loadItemsDispose)
        
    }
    
    func resultResponse(result: ApiProvider.IniciativeListResult) {
        switch result {
            case let .success(response):
                let mappedCells = response.items.map({ IniciativeCell(model: $0) })
                cells.accept(Array(Set(cells.value + mappedCells)))
            case let .failure(err):
                error.onNext(err)
        }
    }
    
}
