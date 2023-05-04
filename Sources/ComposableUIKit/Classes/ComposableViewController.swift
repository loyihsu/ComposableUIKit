//
//  ComposableViewController.swift
//  ComposableUIKit
//
//  Created by Loyi Hsu on 2023/5/3.
//

import Combine
import ComposableArchitecture
import UIKit

open class ComposableViewController<State, Action>: UIViewController where State: Equatable {
    // MARK: - Properties

    private var store: Store<State, Action>!
    private var viewStore: ViewStore<State, Action>!
    private var cancellables = Set<AnyCancellable>()

    private var isSetup = false

    // MARK: - Helpers

    public func setupStore() {
        viewStore?.publisher
            .sink(
                receiveValue: { [weak self] state in
                    self?.update(to: state)
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - Public APIs

    /// Initialise a `ComposableViewController` using a `Store<State, Action>`.
    public convenience init(store: Store<State, Action>) {
        self.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        setup(with: store)
    }

    /// Perform the setup view and setup store. This is intended for initial setup and will only be effective once, and is accessible for uses in the case an init is not performed through the `.init(store:)` endpoint. Calls after the first time will be ignored.
    public func setup(with store: Store<State, Action>) {
        guard !isSetup else { return }
        self.store = store
        viewStore = ViewStore(store)
        setupView()
        setupStore()
        isSetup = true
    }

    /// The current state.
    public var state: State? {
        viewStore?.state
    }

    /// Using this method allows you to send an action directly from the button.
    public func addAction(_ action: Action, to control: UIControl, for controlEvent: UIControl.Event) {
        control.addAction(for: controlEvent) { [weak self] in
            self?.viewStore.send(action)
        }
    }

    /// Send an action to the underlying view store.
    public func send(_ action: Action) {
        viewStore.send(action)
    }

    /// Scoping parent domain to child domain.
    public func scope<ChildState, ChildAction>(
        state: @escaping (State) -> ChildState,
        action: @escaping (ChildAction) -> Action
    ) -> Store<ChildState, ChildAction> {
        store.scope(
            state: state,
            action: action
        )
    }

    // MARK: - Bindings

    /// Override this method to setup view.
    open func setupView() {
        print("View is set up.")
    }

    /// Override this method to update state.
    open func update(to state: State) {
        print("State updated!")
    }
}
