//
//  CustomTapGesture.swift
//  pincode_checker
//
//  Created by Mark Khmelnitskii on 04.06.2022.
//

import SwiftUI
import UIKit

final class CustomTapGesture: UITapGestureRecognizer {

    var didBeginTouch: (() -> Void)?
    var didEndTouch: (() -> Void)?

    init(target: Any?, action: Selector?, didBeginTouch: (()->Void)? = nil, didEndTouch: (()->Void)? = nil) {
        super.init(target: target, action: action)
        self.didBeginTouch = didBeginTouch
        self.didEndTouch = didEndTouch
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.didBeginTouch?()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.didEndTouch?()
    }
}

struct TouchesHandler: UIViewRepresentable {
    var didBeginTouch: (()->Void)?
    var didEndTouch: (()->Void)?

    func makeUIView(context: UIViewRepresentableContext<TouchesHandler>) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(context.coordinator.makeGesture(didBegin: didBeginTouch, didEnd: didEndTouch))
        return view;
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TouchesHandler>) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator {
        @objc
        func action(_ sender: Any?) {
        }

        func makeGesture(didBegin: (()->Void)?, didEnd: (()->Void)?) -> CustomTapGesture {
            CustomTapGesture(target: self, action: #selector(self.action(_:)), didBeginTouch: didBegin, didEndTouch: didEnd)
        }
    }
    typealias UIViewType = UIView
}
