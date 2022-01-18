import XCTest
import Nimble
import StateMachine

class StateMachineTests: XCTestCase {
    enum TestEvent: Event {
        case foo
    }

    class TestState: State {
        var name: String
        var event: TestEvent?
        let onEntryClosure: (() -> Void)?
        let handleClosure: (() throws -> State)?
        let onExitClosure: (() -> Void)?

        init(name: String, onEntryClosure: (() -> Void)? = nil, handleClosure: (() throws -> State)? = nil, onExitClosure: (() -> Void)? = nil) {
            self.name = name
            self.onEntryClosure = onEntryClosure
            self.handleClosure = handleClosure
            self.onExitClosure = onExitClosure
        }

        func onEntry() {
            onEntryClosure?()
        }

        func handle(event: Event) throws -> State {
            self.event = event as? TestEvent
            guard let closure = handleClosure else { return self }
            return try closure()
        }

        func onExit() {
            onExitClosure?()
        }
    }

    func testEntersStartState() {
        var entered = false
        _ = StateMachine(startState: TestState(name: "", onEntryClosure: { entered = true }))
        expect(entered) == true
    }

    func testDeliversEventsToCurrentState() {
        let state = TestState(name: "")
        let stateMachine = StateMachine(startState: state)
        stateMachine.handle(event: TestEvent.foo)
        expect(state.event) == .foo
    }

    func testHandlingEventReturnsNextState() {
        let start = TestState(name: "start", handleClosure: { TestState(name: "next") })
        let stateMachine = StateMachine(startState: start)
        stateMachine.handle(event: TestEvent.foo)
        expect((stateMachine.currentState as? TestState)?.name) == "next"
    }

    func testLeavingStateInvokesOnExit() {
        var exited = false
        let state = TestState(name: "", onExitClosure: { exited = true })
        let stateMachine = StateMachine(startState: state)
        stateMachine.handle(event: TestEvent.foo)
        expect(exited) == true
    }

    func testErrorHandlingEventResetsStateMachine() {
        var exited = false
        let nextState = TestState(name: "next", handleClosure: { throw StateMachine.Error.eventNotHandled }, onExitClosure: { exited = true })
        let start = TestState(name: "start", handleClosure: { nextState })
        let stateMachine = StateMachine(startState: start)
        stateMachine.handle(event: TestEvent.foo)
        stateMachine.handle(event: TestEvent.foo)
        expect((stateMachine.currentState as? TestState)?.name) == "start"
        expect(exited) == false
    }
}
