//
//  NumpadButton.swift
//  pincode_checker
//
//  Created by Mark Khmelnitskii on 04.06.2022.
//

import SwiftUI

enum NumberType {
    case number(Int)
    case delete
    case question
    case unknown
}

struct NumpadButton: View {
    let buttonText: String
    @Binding var buttonFrames: [CGRect]
    var numberType = NumberType.unknown
    public var actionHandler: ((NumberType) -> Void)
    @State private var isButtonAlreadyAdded = false
    @State private var isPressed = false
    var body: some View {
        if let buttonText = Int(buttonText) {
            ZStack {
                Circle()
                    .foregroundColor(Color.white.opacity(0.1))
                Text("\(buttonText)")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
            .opacity(isPressed ? 0.3 : 1)
            .overlay(TouchesHandler(didBeginTouch: {
                isPressed = true
            }, didEndTouch: {
                isPressed = false
                actionHandler(.number(buttonText))
            }))
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged {
                        if isPressed {
                            actionHandler(.number(buttonText))
                            isButtonAlreadyAdded = true
                            isPressed = false
                        }
                        buttonSwipeGesture(location: $0.location, number: buttonText)
                    })
            .overlay(GeometryReader { geo in
                Color.clear
                    .onAppear {
                        self.buttonFrames[buttonText] = geo.frame(in: .global)
                    }
            })
            .animation(.default.speed(2), value: isPressed)
        } else {
            Button {
                if buttonText == "questionSymbol" {
                    actionHandler(.question)
                } else if buttonText == "DeleteSimbol" {
                    actionHandler(.delete)
                } else {
                    actionHandler(.unknown)
                }
            } label: {
                Image(buttonText)
            }
        }
    }
    func buttonSwipeGesture(location: CGPoint, number: Int) {
        if let match = buttonFrames.firstIndex(where: { $0.contains(location) }) {
            guard !isButtonAlreadyAdded else { return }
            isButtonAlreadyAdded = true
            actionHandler(.number(match))
        } else {
            isButtonAlreadyAdded = false
        }
    }
}
