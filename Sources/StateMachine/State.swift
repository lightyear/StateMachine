//
//  State.swift
//  StateMachine
//
//  Created by Steve Madsen on 1/18/22.
//

import Foundation

public protocol Event {
}

public protocol State {
    func onEntry(_ stateMachine: StateMachine)
    func handle(_ stateMachine: StateMachine, event: Event) throws -> State
    func onExit(_ stateMachine: StateMachine)
}

public extension State {
    func onEntry(_ stateMachine: StateMachine) {
    }

    func handle(_ stateMachine: StateMachine, event: Event) throws -> State {
        throw StateMachine.Error.eventNotHandled
    }

    func onExit(_ stateMachine: StateMachine) {
    }
}
