//
//  Lifetime.swift
//  LinUtil
//
//  Created by lin on 03/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation

/// Represents the lifetime of an object, and provides a hook to observe when
/// the object deinitializes.
public final class Lifetime {
    /// MARK: Type properties and methods
//    /// Factory method for creating a `Lifetime` and its associated `Token`.
//    public static func makeLifetime() -> (Lifetime, Token) {
//        let token = Token()
//        return (Lifetime(token), token)
//    }
//    
//    /// A `Lifetime` that has already ended.
//    public static var empty: Lifetime {
//        return Lifetime(ended: .empty)
//    }
    
    /// MARK: Instance properties
    /// A signal that sends a `completed` event when the lifetime ends.
//    public let ended: Signal<(), NoError>
//    
//    /// MARK: Initializers
//    /// Initialize a `Lifetime` object with the supplied ended signal.
//    ///
//    /// - parameters:
//    ///   - signal: The ended signal.
//    private init(ended signal: Signal<(), NoError>) {
//        ended = signal
//    }
    private init(){}
    
    /// Initialize a `Lifetime` from a lifetime token, which is expected to be
    /// associated with an object.
    ///
    /// - important: The resulting lifetime object does not retain the lifetime
    ///              token.
    ///
    /// - parameters:
    ///   - token: A lifetime token for detecting the deinitialization of the
    ///            associated object.
    public convenience init(_ token: Token) {
        self.init();
        token.action = self.fireDeinit;
//        self.init(ended: token.ended)
    }
    
    public func onDeinit(_ action:@escaping (()->())){
        actions.append(action);
    }
    
    private func fireDeinit(){
        for action in actions {
            action();
        }
    }
    
    private var actions = [(()->())]();
    
    /// A token object which completes its signal when it deinitializes.
    ///
    /// It is generally used in conjuncion with `Lifetime` as a private
    /// deinitialization trigger.
    ///
    /// ```
    /// class MyController {
    ///		private let (lifetime, token) = Lifetime.makeLifetime()
    /// }
    /// ```
    public final class Token {
        /// A signal that sends a Completed event when the lifetime ends.
//        fileprivate let ended: Signal<(), NoError>
        
//        private let endedObserver: Signal<(), NoError>.Observer
        
        fileprivate var action:(()->())? = nil;
        
        public init() {
//            (ended, endedObserver) = Signal.pipe()
        }
        
        deinit {
//            endedObserver.sendCompleted()
            if let action = action {
                action();
            }
        }
    }
}
