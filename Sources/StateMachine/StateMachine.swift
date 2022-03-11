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
            do {
                try self.currentState.onEntry(self)
            } catch {
                log("State machine: start state threw onEntry", error: error)
            }
        }
    }

    open func handle(event: Event) {
        context.sync {
            do {
                log("State machine: \(currentState) handle \(event)")
                let nextState = try currentState.handle(self, event: event)
                try currentState.onExit(self)
                log("State machine: next state is \(nextState)")
                currentState = nextState
                try currentState.onEntry(self)
            } catch {
                log("State machine: error thrown while handling event; resetting", error: error)
                reset()
            }
        }
    }

    open func log(_ message: String, error: Swift.Error? = nil) {
    }

    open func reset() {
        do {
            currentState = startState
            try currentState.onEntry(self)
        } catch {
            log("State machine: error thrown during reset", error: error)
        }
    }
}
