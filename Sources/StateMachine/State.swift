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
    func onEntry()
    func handle(event: Event) throws -> State
    func onExit()
}

public extension State {
    func onEntry() {
    }

    func handle(event: Event) throws -> State {
        throw StateMachine.Error.eventNotHandled
    }

    func onExit() {
    }
}
