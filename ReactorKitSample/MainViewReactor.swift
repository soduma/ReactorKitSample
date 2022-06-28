//
//  MainViewReactor.swift
//  ReactorKitSample
//
//  Created by 장기화 on 2022/06/28.
//

import RxSwift
import ReactorKit

class MainViewReactor: Reactor {
    enum Action {
        case plus
        case minus
    }
    
    enum Mutation {
        case plusValue
        case minusValue
        case SetLoading(Bool)
    }
    
    struct State {
        var value: Int
        var isLoading: Bool
    }
    
    let initialState: State
    
    init() {
        initialState = State(value: 0, isLoading: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .plus:
            return Observable.concat([
                Observable.just(Mutation.SetLoading(true)),
                Observable.just(Mutation.plusValue).delay(.milliseconds(100), scheduler: MainScheduler.instance),
                Observable.just(Mutation.SetLoading(false))
            ])
        case .minus:
            return Observable.concat([
                Observable.just(Mutation.SetLoading(true)),
                Observable.just(Mutation.minusValue).delay(.milliseconds(100), scheduler: MainScheduler.instance),
                Observable.just(Mutation.SetLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .plusValue:
            state.value += 1
        case .minusValue:
            state.value -= 1
        case .SetLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
