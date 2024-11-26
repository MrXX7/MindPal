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
    @State private var isLoading = false

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

                if isLoading {
                    ProgressView()
                        .padding(.leading, 10)
                } else {
                    Button(action: sendMessage) {
                        Text("Send")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .padding()
    }

    func sendMessage() {
        guard !userInput.isEmpty else { return }
        isLoading = true
        callOpenAIAPI(prompt: userInput) { response in
            DispatchQueue.main.async {
                aiResponse = response ?? "Something went wrong. Please try again."
                userInput = ""
                isLoading = false
            }
        }
    }
}

func callOpenAIAPI(prompt: String, completion: @escaping (String?) -> Void) {
    let apiKey = "YOUR_API_KEY_HERE"
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!

    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(apiKey)"
    ]

    let body: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [
            ["role": "system", "content": "You are a helpful assistant."],
            ["role": "user", "content": prompt]
        ],
        "max_tokens": 150
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = json["choices"] as? [[String: Any]],
           let message = choices.first?["message"] as? [String: Any],
           let content = message["content"] as? String {
            completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            completion(nil)
        }
    }

    task.resume()
}


