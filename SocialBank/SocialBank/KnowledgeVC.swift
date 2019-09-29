//
//  KnowledgeVC.swift
//  SocialBank
//
//  Created by Вильян Яумбаев on 28/09/2019.
//  Copyright © 2019 Вильян Яумбаев. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD

class KnowledgeVC: UIViewController {
    
    let collection: UICollectionView
    let topBar = InactiveListtopBar()
    
    let disposeBag = DisposeBag()
    
    let cells = BehaviorRelay<[KnowledgeModel]>(value: [])
    
    let provader: ApiProvider
    
    init(provider: ApiProvider) {
        self.provader = provider
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView(frame: CGRect(),
                                          collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
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
        
        topBar.titleLabel.text = "Финансовая грамотность"
        topBar.searchBtn.isHidden = true
        
        collection.backgroundColor = .white
        collection.register(KnowledgeCollectionCell.self,
                            forCellWithReuseIdentifier: KnowledgeCollectionCell.reuseIdentifier)
        collection.delegate = self
        collection.dataSource = self
        
        constrain(view, collection, topBar) { (view, collection, topBar) in
            topBar.top == view.top
            topBar.leading == view.leading
            topBar.trailing == view.trailing
            collection.top == topBar.bottom
            collection.leading == view.leading
            collection.trailing == view.trailing
            collection.bottom == view.bottom
        }
        
        let titles = ["Простым языком", "Инфографика", "Детям"]
        topBar.controlBar.commaSeperatedButtonTitles = titles.joined(separator: ",")
        topBar.controlBar.setIndex(index: 0)
        /*
         https://ibb.co/47BwBW0
         https://ibb.co/L6Cd67C
         https://ibb.co/Pg5nWPk
         https://ibb.co/rbGd5xS
         */
        cells.accept([KnowledgeModel(id: 1,
                                     title: "Зачем стране нужен золотой резерв?",
                                     comment: "Это золотые слитки как накопление, как «заначка на черный день» только для государства...",
                                     image: "https://ibb.co/rbGd5xS"),
                      KnowledgeModel(id: 2,
                                     title: "ВВП? Что это?",
                                     comment: "Стоимость всех товаров произведенных за год в стране",
                                     image: "https://ibb.co/Pg5nWPk"),
                      KnowledgeModel(id: 3,
                                     title: "Минусы дефляции",
                                     comment: "Товаров много, а денег в обороте мало, поэтому государству нужно напечатать еще денег.",
                                     image: "https://ibb.co/L6Cd67C"),
                      KnowledgeModel(id: 4,
                                     title: "Зачем стране нужен золотой резерв?",
                                     comment: "Это золотые слитки как накопление, как «заначка на черный день» только для государства...",
                                     image: "https://ibb.co/47BwBW0"),
                      KnowledgeModel(id: 5,
                                     title: "ВВП? Что это?",
                                     comment: "Стоимость всех товаров произведенных за год в стране",
                                     image: "https://ibb.co/Pg5nWPk"),
                      KnowledgeModel(id: 6,
                                     title: "Минусы дефляции",
                                     comment: "Товаров много, а денег в обороте мало, поэтому государству нужно напечатать еще денег.",
                                     image: "https://ibb.co/L6Cd67C"),
                      KnowledgeModel(id: 7,
                                     title: "Зачем стране нужен золотой резерв?",
                                     comment: "Это золотые слитки как накопление, как «заначка на черный день» только для государства...",
                                     image: "https://ibb.co/47BwBW0"),
                      KnowledgeModel(id: 8,
                                     title: "ВВП? Что это?",
                                     comment: "Стоимость всех товаров произведенных за год в стране",
                                     image: "https://ibb.co/Pg5nWPk"),
                      KnowledgeModel(id: 9,
                                     title: "Минусы дефляции",
                                     comment: "Товаров много, а денег в обороте мало, поэтому государству нужно напечатать еще денег.",
                                     image: "https://ibb.co/L6Cd67C")])
    }
    
    func openInfo() {
        let vc = ScrollVC(image: UIImage(named: "infoScreen")!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupModel() {
        
        cells.asObservable().subscribe(onNext: { [unowned self] _ in
            self.collection.reloadData()
            }).disposed(by: disposeBag)
        
        collection.rx.itemSelected.withLatestFrom(cells) {($0, $1)}
            .subscribe(onNext: { [unowned self] data in
                let model = data.1[data.0.row]
                self.openInfo()
            }).disposed(by: disposeBag)
    }
    
}

extension KnowledgeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KnowledgeCollectionCell.reuseIdentifier, for: indexPath) as! KnowledgeCollectionCell
        cell.setup(item: cells.value[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width - 32
        let item = cells.value[indexPath.row]
        let h = KnowledgeCollectionCell.getHeight(w: w, item: item)
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
