//  Reachability+Rx.swift
//  Unbabel
//
//  Created by Ivan Bruel on 22/03/2017.
//  Copyright © 2017 Unbabel, Inc. All rights reserved.
//

import Foundation
import RxSwift
import Reachability

extension Reactive where Base: NotificationCenter {
    public func notification(_ name: Notification.Name?, object: AnyObject? = nil) -> Observable<Notification> {
        return Observable.create { [weak object] observer in
            let nsObserver = self.base.addObserver(forName: name, object: object, queue: nil) { notification in
                observer.on(.next(notification))
            }
            
            return Disposables.create {
                self.base.removeObserver(nsObserver)
            }
        }
    }
}
extension Reachability: ReactiveCompatible { }
public extension Reactive where Base: Reachability {
    
    public static var reachabilityChanged: Observable<Reachability> {
        return NotificationCenter.default.rx.notification(Notification.Name.reachabilityChanged)
            .flatMap { notification -> Observable<Reachability> in
                guard let reachability = notification.object as? Reachability else {
                    return .empty()
                }
                return .just(reachability)
        }
    }
    
    public static var status: Observable<Reachability.Connection> {
        return reachabilityChanged
            .map { $0.connection }
    }
    
    public static var isReachable: Observable<Bool> {
        return reachabilityChanged
            .map { $0.connection != .none }
    }
    
    public static var isConnected: Observable<Void> {
        return isReachable
            .filter { $0 }
            .map { _ in Void() }
    }
    
    public static var isDisconnected: Observable<Void> {
        return isReachable
            .filter { !$0 }
            .map { _ in Void() }
    }
}

public extension ObservableType {
    
    public func retryOnConnect(timeout: TimeInterval) -> Observable<E> {
        return retryWhen { _ in
            return Reachability.rx.isConnected
                .timeout(timeout, scheduler: MainScheduler.asyncInstance)
        }
    }
}

