//
//  ContentView.swift
//  MindPal
//
//  Created by Oncu Can on 19.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput = ""
    @State private var aiResponse = "Hello! How can I help you?"

    var body: some View {
        VStack {
            ScrollView {
                Text(aiResponse)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            HStack {
                TextField("Ask a question...", text: $userInput)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                Button(action: sendMessage) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }

    func sendMessage() {
        // The user sends a message, and the AI provides a response
        aiResponse = getAIResponse(for: userInput)
        userInput = ""
    }
}
import NaturalLanguage

func getAIResponse(for input: String) -> String {
    let text = input.lowercased()

    if text.contains("hello") {
        return "Hello! How are you?"
    } else if text.contains("how are you") {
        return "I am just a virtual friend, but I'm doing great!"
    } else {
        return "I didn't quite understand that. Could you ask something else?"
    }
}

