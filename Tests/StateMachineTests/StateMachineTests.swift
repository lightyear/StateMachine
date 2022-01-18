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
        let onEntryClosure: ((StateMachine) -> Void)?
        let handleClosure: ((StateMachine, Event) throws -> State?)?
        let onExitClosure: ((StateMachine) -> Void)?

        init(name: String, onEntryClosure: ((StateMachine) -> Void)? = nil, handleClosure: ((StateMachine, Event) throws -> State?)? = nil, onExitClosure: ((StateMachine) -> Void)? = nil) {
            self.name = name
            self.onEntryClosure = onEntryClosure
            self.handleClosure = handleClosure
            self.onExitClosure = onExitClosure
        }

        func onEntry(_ stateMachine: StateMachine) {
            onEntryClosure?(stateMachine)
        }

        func handle(_ stateMachine: StateMachine, event: Event) throws -> State {
            self.event = event as? TestEvent
            guard let closure = handleClosure else { return self }
            return try closure(stateMachine, event) ?? self
        }

        func onExit(_ stateMachine: StateMachine) {
            onExitClosure?(stateMachine)
        }
    }

    func testEntersStartState() {
        var entered = false
        _ = StateMachine(startState: TestState(name: "", onEntryClosure: { _ in entered = true }))
        expect(entered) == true
    }

    func testDeliversEventsToCurrentState() {
        let state = TestState(name: "")
        let stateMachine = StateMachine(startState: state)
        stateMachine.handle(event: TestEvent.foo)
        expect(state.event) == .foo
    }

    func testHandlingEventReturnsNextState() {
        let start = TestState(name: "start", handleClosure: { _, _ in TestState(name: "next") })
        let stateMachine = StateMachine(startState: start)
        stateMachine.handle(event: TestEvent.foo)
        expect((stateMachine.currentState as? TestState)?.name) == "next"
    }

    func testLeavingStateInvokesOnExit() {
        var exited = false
        let state = TestState(name: "", onExitClosure: { _ in exited = true })
        let stateMachine = StateMachine(startState: state)
        stateMachine.handle(event: TestEvent.foo)
        expect(exited) == true
    }

    func testErrorHandlingEventResetsStateMachine() {
        var exited = false
        let nextState = TestState(name: "next", handleClosure: { _, _ in throw StateMachine.Error.eventNotHandled }, onExitClosure: { _ in exited = true })
        let start = TestState(name: "start", handleClosure: { _, _ in nextState })
        let stateMachine = StateMachine(startState: start)
        stateMachine.handle(event: TestEvent.foo)
        stateMachine.handle(event: TestEvent.foo)
        expect((stateMachine.currentState as? TestState)?.name) == "start"
        expect(exited) == false
    }
}
