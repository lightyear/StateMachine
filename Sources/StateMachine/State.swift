//
//  State.swift
//  StateMachine
//
//  Created by Steve Madsen on 1/18/22.
//  Copyright © 2022 Light Year Software, LLC
//

import Foundation

public protocol Event {
}

public protocol State {
    func onEntry(_ stateMachine: StateMachine) throws
    func handle(_ stateMachine: StateMachine, event: Event) throws -> State
    func onExit(_ stateMachine: StateMachine) throws
}

public extension State {
    func onEntry(_ stateMachine: StateMachine) throws {
    }

    func handle(_ stateMachine: StateMachine, event: Event) throws -> State {
        throw StateMachine.Error.eventNotHandled
    }

    func onExit(_ stateMachine: StateMachine) throws {
    }
}
