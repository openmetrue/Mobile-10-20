//
//  ContentView.swift
//  pincode_checker
//
//  Created by Mark Khmelnitskii on 04.06.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var password: [(Int, UUID)] = []
    @State private var isActiveAlert: (Bool, AlertPasswordType) = (false, .unownError)
    @State private var buttonFrames = [CGRect](repeating: .zero, count: 10)
    
    private let screenHeight = UIScreen.main.bounds.height
    
    private let keychainKey = "passwordMailRu"
    private let keychainHelper = KeychainHelper()
    
    private var buttons: [String] = ["1","2","3","4","5","6","7","8","9","questionSymbol","0", "DeleteSimbol"]
    private var columns = Array(repeating: GridItem(.flexible(), spacing: 30), count: 3)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RadialGradient(colors: [Color("BackgroundRadialGradient1"),
                                    Color("Background"),
                                    Color("BackgroundRadialGradient2")], center: .bottomLeading, startRadius: 0, endRadius: screenHeight*1.2)
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Spacer()
                Image("mailru")
                    .padding(.top, 10)
                Spacer()
                Text("Введите пин-код")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                ZStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        ForEach(0..<4) { _ in
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.white)
                                .frame(width: 12, height: 12)
                                .padding(.horizontal, 13)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach($password, id: \.self.1) { _ in
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 12, height: 12)
                                .padding(.horizontal, 13)
                        }
                    }
                }
                .animation(.default.speed(2), value: password.count)
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(buttons, id: \.self) { item in
                        NumpadButton(buttonText: item, buttonFrames: $buttonFrames) { type in
                            switch type {
                            case .number(let int):
                                guard password.count < 4 else { password = []; return }
                                password.append((int, UUID()))
                                if password.count == 4 {
                                    sendPassword { result in
                                        switch result {
                                        case true:
                                            isActiveAlert = (true, .success)
                                        case false:
                                            isActiveAlert = (true, .wrong)
                                        }
                                    }
                                }
                            case .delete:
                                guard password.count > 0 else { return }
                                password.removeLast()
                            case .question:
                                restorePassword {
                                    isActiveAlert = (true, .restoring)
                                }
                            case .unknown:
                                isActiveAlert = (true, .unownError)
                            }
                        }
                        .frame(width: 75, height: 75, alignment: .center)
                        .padding(.bottom, 15)
                    }
                }
                .padding(30)
                Spacer()
            }
            .alertView($isActiveAlert)
        }
        
    }
    func sendPassword(_ handler: @escaping (Bool) -> Void) {
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                password = []
            }
        }
        guard let data = keychainHelper.read(service: keychainKey) else {
            let data = Data("\(password.map { $0.0 })".utf8)
            keychainHelper.save(data, service: keychainKey)
            isActiveAlert = (true, .restored)
            return
        }
        if "\(password.map { $0.0 })" == String(data: data, encoding: .utf8)! {
            handler(true)
        } else {
            handler(false)
        }
    }
    func restorePassword(_ handler: @escaping () -> Void) {
        password = []
        keychainHelper.delete(service: keychainKey)
        handler()
    }
}

