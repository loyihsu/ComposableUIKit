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

    private var store: ViewStore<State, Action>!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers

    private func setupStore() {
        store?.publisher
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

        self.store = ViewStore(store)
        setupStore()
    }

    /// Initialise a `ComposableViewController` using a `ViewStore<State, Action>`.
    public convenience init(viewStore: ViewStore<State, Action>) {
        self.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        store = viewStore
        setupStore()
    }

    /// Using this method allows you to send an action directly from the button.
    public func addAction(_ action: Action, to control: UIControl, for controlEvent: UIControl.Event) {
        control.addAction(for: controlEvent) { [weak self] in
            self?.store.send(action)
        }
    }

    // MARK: - Bindings

    /// Override this method to update state.
    open func update(to _: State) {
        print("State updated!")
    }
}

// MARK: - Extensions

private extension UIControl {
    func addAction(
        for controlEvents: UIControl.Event = .touchUpInside,
        _ closure: @escaping () -> Void
    ) {
        if #available(iOS 14.0, *) {
            addAction(
                UIAction { _ in
                    closure()
                },
                for: controlEvents
            )
        } else {
            @objc class ClosureSleeve: NSObject {
                let closure: () -> Void
                init(_ closure: @escaping () -> Void) {
                    self.closure = closure
                }

                @objc func invoke() {
                    closure()
                }
            }
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(
                self,
                "\(UUID())",
                sleeve,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
            )
        }
    }
}
