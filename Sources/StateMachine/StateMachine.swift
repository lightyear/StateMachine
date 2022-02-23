//
//  StateMachine.swift
//  StateMachine
//
//  Created by Steve Madsen on 1/18/22.
//  Copyright © 2022 Light Year Software, LLC
//

import Foundation

public class StateMachine {
    public enum Error: Swift.Error {
        case eventNotHandled
    }

    private let startState: State
    private let context: ExecutionContext
    public private(set) var currentState: State

    private init(state: State, context: ExecutionContext?) {
        self.startState = state
        currentState = state
        self.context = context ?? DispatchQueue(label: "state machine")
    }

    convenience public init(startState: State, context: ExecutionContext? = nil) {
        self.init(state: startState, context: context)
        self.context.sync {
            self.currentState.onEntry(self)
        }
    }

    public func handle(event: Event) {
        context.sync {
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
