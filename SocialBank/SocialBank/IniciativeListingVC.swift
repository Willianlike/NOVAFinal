//
//  IniciativeListingVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 27/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD

class IniciativeListingVC: UIViewController {
    
    let collection: UICollectionView
    let topBar = InactiveListtopBar()
    
    let vm: IniciativeListingVM
    let disposeBag = DisposeBag()
    
    init(provider: ApiProvider) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView(frame: CGRect(),
                                          collectionViewLayout: layout)
        vm = IniciativeListingVM(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupModel()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(topBar)
        view.addSubview(collection)
        
        collection.backgroundColor = .white
        collection.register(IniciativeListingCellWithImage.self,
                            forCellWithReuseIdentifier: IniciativeListingCellWithImage.reuseIdentifier)
        collection.register(IniciativeListingCell.self,
                            forCellWithReuseIdentifier: IniciativeListingCell.reuseIdentifier)
        collection.delegate = self
        
        constrain(view, collection, topBar) { (view, collection, topBar) in
            topBar.top == view.top
            topBar.leading == view.leading
            topBar.trailing == view.trailing
            collection.top == topBar.bottom
            collection.leading == view.leading
            collection.trailing == view.trailing
            collection.bottom == view.bottom
        }
        
        let firstPart = "Популярное"
        let secondPart = "Новое"
        topBar.controlBar.commaSeperatedButtonTitles = firstPart + "," + secondPart
        topBar.controlBar.setIndex(index: 0)
    }
    
    func openIniciative(model: BankIniciativeModel) {
        let vc = IniciativeFullVC(model: model, provider: vm.provider)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupModel() {
        vm.cells.debug()
            .map({ [AnimatableSectionModel<Int, IniciativeCell>(model: 0, items: $0)] })
            .bind(to: collection.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        collection.rx.itemSelected.withLatestFrom(vm.cells) {($0, $1)}
            .subscribe(onNext: { [unowned self] data in
                let model = data.1[data.0.row]
                self.openIniciative(model: model.getIniciativeModel())
            }).disposed(by: disposeBag)
        
//        topBar.controlBar.rx.controlEvent(UIControl.Event.valueChanged)
//            .map({ [unowned self] _ in
//                return self.topBar.controlBar.selectedSegmentIndex
//            }).distinctUntilChanged()
//            .bind(to: vm.filterSelected).disposed(by: disposeBag)
//
//        vm.filterSelected.distinctUntilChanged()
//            .subscribe(onNext: { [unowned self] index in
//            self.topBar.controlBar.setIndex(index: index)
//            }).disposed(by: disposeBag)
    }
    
    func getDataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, IniciativeCell>> {
        return RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, IniciativeCell>> (configureCell: { [unowned self] _, collectionView, indexPath, element in
            switch element {
            case let .withoutImage(item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IniciativeListingCell.reuseIdentifier,
                                                              for: indexPath) as! IniciativeListingCell
                cell.setupCell(item: item)
                return cell
            case let .withImage(item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IniciativeListingCellWithImage.reuseIdentifier,
                                                              for: indexPath) as! IniciativeListingCellWithImage
                cell.setupCell(item: item)
                return cell
                
            }
            })
    }
    
}

extension IniciativeListingVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width - 32
        let h = vm.cells.value[indexPath.row].getCellHeight(width: w)
        print(h)
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
}
