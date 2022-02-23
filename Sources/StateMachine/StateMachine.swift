//
//  StateMachine.swift
//  StateMachine
//
//  Created by Steve Madsen on 1/18/22.
//

import Foundation

public class StateMachine {
    public enum Error: Swift.Error {
        case eventNotHandled
    }

    private let startState: State
    private let queue: DispatchQueue
    public private(set) var currentState: State

    private init(state: State, queue: DispatchQueue?) {
        self.startState = state
        currentState = state
        self.queue = queue ?? DispatchQueue(label: "state machine")
    }

    convenience public init(startState: State, queue: DispatchQueue? = nil) {
        self.init(state: startState, queue: queue)
        self.queue.sync {
            self.currentState.onEntry(self)
        }
    }

    public func handle(event: Event) {
        queue.sync {
            do {
                let nextState = try currentState.handle(self, event: event)
                currentState.onExit(self)
                nextState.onEntry(self)
                currentState = nextState
            } catch {
                currentState = startState
            }
        }
    }
}
