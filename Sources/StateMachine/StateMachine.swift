//
//  StateMachine.swift
//  StateMachine
//
//  Created by Steve Madsen on 1/18/22.
//

public class StateMachine {
    public enum Error: Swift.Error {
        case eventNotHandled
    }

    private let startState: State
    public private(set) var currentState: State

    public init(startState: State) {
        self.startState = startState
        currentState = startState
        currentState.onEntry()
    }

    public func handle(event: Event) {
        do {
            let nextState = try currentState.handle(event: event)
            currentState.onExit()
            nextState.onEntry()
            currentState = nextState
        } catch {
            currentState = startState
        }
    }
}
