//
//  MachineLearningHelper.swift
//  TestSnap
//
//  Created by 佐伯小遥 on 2025/05/13.
//

import Foundation
import OpenAI
import UIKit

class MachineLearningHelper {
    static let shared = MachineLearningHelper()
    private let openAI = OpenAI(apiToken: "YOUR_API_KEY")
    
    // 画像から食材を生成
    func analyzeImage(imageData: Data) async -> String {
        do {
            let query = ChatQuery(messages: [
                .user(.init(content: .vision([
                    .chatCompletionContentPartTextParam(.init(text: "以下の画像に写っている食材を、シンプルに食材名だけできるだけ列挙してください。")),
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .auto)))
                ])))
            ], model: .gpt4_o, maxTokens: 100)

            let result = try await openAI.chats(query: query)
            if let choice = result.choices.first,
               let text = choice.message.content {
                return text
            }
        } catch {
            print("分析失敗: \(error)")
        }
        return "分析に失敗しました"
    }
    
    // 食材が写っているか判定
    func checkFoodInImage(imageData: Data) async -> String {
        do {
            let query = ChatQuery(messages: [
                .user(.init(content: .vision([
                    .chatCompletionContentPartTextParam(.init(text: "以下の画像に食材が写っていたら「true」を、そうでなければ「false」を返して")),
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .auto)))
                ])))
            ], model: .gpt4_o, maxTokens: 100)

            let result = try await openAI.chats(query: query)
            if let choice = result.choices.first,
               let text = choice.message.content {
                return text
            }
        } catch {
            print("判定失敗: \(error)")
        }
        return "false"
    }
    
    // メニュー作成
    func fetchIdea(receivedText: String) async -> String {
        do {
            let query = ChatQuery(messages:[
                .init(role: .system, content: receivedText + "を使った料理を5つ提案してください。料理の名前だけ書いてください。言語は日本語で答えて。")!,
            ], model: .gpt4_o_mini)
            
            let result = try await openAI.chats(query: query)
            if let choice = result.choices.first,
               let text = choice.message.content {
                    return text
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return "an error occurred"
    }
}
