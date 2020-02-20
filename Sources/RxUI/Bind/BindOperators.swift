//
//  BindOperators.swift
//  Audiometer
//
//  Created by Sergey Kachan on 1/30/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa

precedencegroup BindingPipePrecedenceGroup {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

infix operator  ||>:  BindingPipePrecedenceGroup
infix operator <||>:  BindingPipePrecedenceGroup

func ||><A:ObservableConvertibleType,B:ObserverType>(lhs: A, rhs: B) -> Disposable where A.E == B.E {
    return lhs.asObservable().bind(to: rhs)
}

func ||><A:ObservableConvertibleType,B>(lhs: A, rhs: @escaping (A.E)->B) -> Observable<B> {
    return lhs.asObservable().map(rhs)
}

func ||><A:ObservableConvertibleType,B>(lhs: A, rhs: (Observable<A.E>)->B) -> B {
    return rhs(lhs.asObservable())
}

func ||>(lhs: Disposable, rhs: DisposeBag) {
    lhs.disposed(by: rhs)
}

func ||>(lhs: Observable<Void>, rhs: DisposeBag) {
    lhs.subscribe() ||> rhs
}

func ||><A:ObservableType, B:ObserverType>(lhs: A, rhs: B) -> Disposable where B.E == A.E? {
    return lhs.bind(to: rhs)
}

func ||><A:ObservableType, E>(lhs: A, rhs: PublishRelay<E>) -> Disposable where E == A.E {
    return lhs.bind(to: rhs)
}

func ||><A:ObservableType, E>(lhs: A, rhs: Variable<E>) -> Disposable where E == A.E {
    return lhs.bind(to: rhs)
}

func ||><A:ObservableType, E>(lhs: A, rhs: Variable<E>) -> Disposable where A.E == E? {
    return lhs.filterNil() ||> rhs
}

func ||><A:ObservableType>(lhs: A, rhs: Variable<A.E?>) -> Disposable {
    return lhs.bind(to: rhs)
}

func ||><A:ObserverType>(lhs: Variable<A.E>, rhs: A) -> Disposable {
    return lhs.asObservable() ||> rhs
}

func ||><A:ObservableType, E: RawRepresentable>(lhs: A, rhs: Variable<E>) -> Disposable where E.RawValue == A.E {
    return lhs.map { E(rawValue: $0)! }.bind(to: rhs)
}

func ||><A:ObservableType, B:ObserverType, E: RawRepresentable>(lhs: A, rhs: B) -> Disposable where E.RawValue == A.E, B.E == E {
    return lhs.map { E(rawValue: $0)! }.bind(to: rhs)
}

func <||><A:ControlPropertyType, E>(lhs: A, rhs: Variable<E>) -> Disposable where A.E == E {
    return CompositeDisposable(
        rhs.asObservable() ||> lhs.asObserver(),
        lhs.asObservable() ||> rhs
    )
}

func <||><A:ControlPropertyType>(lhs: A, rhs: Variable<String>) -> Disposable where A.E == String? {
    return lhs.orEmpty <||> rhs
}

func <||><A:ControlPropertyType, E: RawRepresentable>(lhs: A, rhs: Variable<E>) -> Disposable where E.RawValue == A.E {
    return CompositeDisposable(
        rhs.asObservable().map { $0.rawValue } ||> lhs.asObserver(),
        lhs.asObservable() ||> rhs
    )
}

func ||><O:ObservableType,A1,A2>(lhs: O, rhs: (A1, A2)) -> Observable<(A1,A2)> where O.E == Void {
    return lhs.mapTo(rhs)
}

func ||><A1,A2>(lhs: Observable<(A1,A2)>, rhs: @escaping (A1,A2)->Void) -> Disposable {
    return lhs.subscribe(onNext: {
        rhs($0.0, $0.1)
    })
}

func ||><A,B,C> (left: @escaping (A) -> B, right: @escaping (B) -> C) -> (A) -> C {
    return { right(left($0)) }
}

func ||><A,B> (left: A, right: @escaping (A) -> B) -> B {
    return right(left)
}
