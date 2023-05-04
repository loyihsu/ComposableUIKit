//
//  ComposableTableViewCell.swift
//  ComposableUIKit
//
//  Created by Loyi Hsu on 2023/5/4.
//

import Combine
import ComposableArchitecture
import UIKit

open class ComposableTableViewCell<State, Action>: UITableViewCell where State: Equatable {
    // MARK: - Properties

    private var store: Store<State, Action>!
    private var viewStore: ViewStore<State, Action>!
    private var cancellables = Set<AnyCancellable>()
    private var isSetup = false

    override open func prepareForReuse() {
        super.prepareForReuse()
        // Clearing all states and bindings for cell reuse to work properly.
        store = nil
        viewStore = nil
        cancellables.forEach { $0.cancel() }
        cancellables = []
        isSetup = false
    }

    // MARK: - Helpers

    private func setupStore() {
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
        self.init(frame: .zero)
        contentView.backgroundColor = .systemBackground
        setup(with: store)
    }

    /// Perform the setup view and setup store. This is intended for initial setup and will only be effective once, and is accessible for uses in the case an init is not performed through the `.init(store:)` endpoint. Calls after the first time will be ignored, except for reuse, where setup status would be cleared for cell reuse to work properly.
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
