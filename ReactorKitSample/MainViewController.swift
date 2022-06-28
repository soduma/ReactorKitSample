//
//  MainViewController.swift
//  ReactorKitSample
//
//  Created by 장기화 on 2022/06/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

class MainViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private lazy var someLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    func bind(reactor: MainViewReactor) {
        plusButton.rx.tap
            .map { Reactor.Action.plus }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        minusButton.rx.tap
            .map { Reactor.Action.minus }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)"}
            .bind(to: someLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func setLayout() {
        [someLabel, minusButton, plusButton, indicatorView]
            .forEach { view.addSubview($0) }
        
        someLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints {
            $0.top.equalTo(someLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(40)
        }
        
        plusButton.snp.makeConstraints {
            $0.top.equalTo(someLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(40)
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(someLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
}

