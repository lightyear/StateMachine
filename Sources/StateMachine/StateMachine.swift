//
//  StateMachine.swift
//  StateMachine
//
//  Created by Steve Madsen on 1/18/22.
//  Copyright © 2022 Light Year Software, LLC
//

import Foundation

open class StateMachine {
    public enum Error: Swift.Error {
        case eventNotHandled
    }

    private let startState: State
    private let context: ExecutionContext
    public private(set) var currentState: State

    public init(startState: State, context: ExecutionContext? = nil) {
        self.startState = startState
        currentState = startState
        self.context = context ?? DispatchQueue(label: "state machine")
        self.context.sync {
            self.currentState.onEntry(self)
        }
    }

    open func handle(event: Event) {
        context.sync {
            do {
                log("State machine: \(currentState) handle \(event)")
                let nextState = try currentState.handle(self, event: event)
                currentState.onExit(self)
                log("State machine: next state is \(nextState)")
                nextState.onEntry(self)
                currentState = nextState
            } catch {
                log("State machine: caught \(error); resetting")
                reset()
            }
        }
    }

    open func log(_ message: String) {
    }

    open func reset() {
        currentState = startState
    }
}
