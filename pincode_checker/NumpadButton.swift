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
    var numberType = NumberType.unknown
    public var actionHandler: ((NumberType) -> Void)
    var body: some View {
        if let buttonText = Int(buttonText) {
            Button {
                actionHandler(.number(buttonText))
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color.white.opacity(0.1))
                    Text("\(buttonText)")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                }
            }
        } else {
            Button {
                if buttonText == "questionSymbol" {
                    actionHandler(.question)
                } else if buttonText == "deleteSimbol" {
                    actionHandler(.delete)
                } else {
                    actionHandler(.unknown)
                }
            } label: {
                Image(buttonText)
            }
        }
    }
}
