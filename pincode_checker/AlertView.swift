//
//  AlertView.swift
//  pincode_checker
//
//  Created by Mark Khmelnitskii on 04.06.2022.
//

import SwiftUI

extension View {
    func alertView(_ show: Binding<(Bool, AlertPasswordType)>) -> some View {
        modifier(AlertView(show: show))
    }
}

enum AlertPasswordType {
    case success
    case wrong
    case restoring
    case restored
    case unownError
    var errorDescription: String {
        switch self {
        case .success:
            return "Пароль верный"
        case .wrong:
            return "Пароль неверный\nПовторите попытку"
        case .restoring:
            return "Задайте новый пароль"
        case .restored:
            return "Новый пароль установлен"
        case .unownError:
            return "Неизвестная ошибка"
        }
    }
}

struct AlertView: ViewModifier {
    @Binding var show: (Bool, AlertPasswordType)
    func body(content: Content) -> some View {
        ZStack {
            content
            Group {
                if show.0 {
                    VStack {
                        HStack(spacing: 0) {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                                .padding(12)
                                .padding(.leading, 4)
                            Text(show.1.errorDescription)
                                .fontWeight(.medium)
                                .padding(.horizontal, 6)
                                .padding(.trailing, 12)
                                .frame(height: 48, alignment: .center)
                        }
                        .foregroundColor(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color.white)
                        )
                        .padding(.top, 40)
                        .onAppear {
                            removeAlert()
                        }
                        
                        Spacer()
                    }
                    .transition(.move(edge: .top))
                }
            }
            .animation(.default, value: show.0)
        }
    }
    private func removeAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            show.0 = false
        }
    }
}
