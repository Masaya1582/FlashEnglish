//
//  QuizManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

final class QuizManager: ObservableObject {
    @Published var allQuizDataArray: [String] = []
    @Published var currentIndex: Int = 0
    @Published var quizIndex: Int = 0
    @Published var formattedQuizArray: [String] = []
    @Published var prodQuizContent: [String] = []

    func setQuiz(isSetNextQuiz: Bool) {
        isSetNextQuiz ? (currentIndex += 1) : (allQuizDataArray = loadCSV(with: "quiz1"))
        print("インデックス: \(currentIndex), データ: \(allQuizDataArray)")
        formattedQuizArray = allQuizDataArray[currentIndex]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        prodQuizContent = formattedQuizArray
        prodQuizContent.shuffle()
    }

    // CSVファイルの読み込み
    private func loadCSV(with name: String) -> [String] {
        guard let csvBundle = Bundle.main.path(forResource: name, ofType: "csv") else {
            fatalError("CSV not found")
        }
        var csvDataArray: [String] = []
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: .utf8)
            csvDataArray = csvData.components(separatedBy: "\n")
            csvDataArray.removeLast()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return csvDataArray
    }
}