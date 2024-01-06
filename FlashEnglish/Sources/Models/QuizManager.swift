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
    @Published var quizData = QuizData()
    @Published var isShowResultView = false
    @Published var quizLevel: QuizLevel?
    @Published var quizContentCount = 0

    func setQuiz(isSetNextQuiz: Bool, quizLevel: QuizLevel) {
        self.quizLevel = quizLevel
        if isSetNextQuiz {
            quizIndex = 0
            currentIndex += 1
            print("カウント: \(quizData.allQuizContents.count)")
        } else {
            quizData.allQuizContents = loadCSV(with: quizLevel.rawValue).shuffled()
            quizContentCount = quizData.allQuizContents.count
        }
        formattedQuizArray = quizData.allQuizContents[currentIndex]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        prodQuizContent = formattedQuizArray
        prodQuizContent.shuffle()
        print("インデックス: \(currentIndex), 全データ: \(quizData.allQuizContents)\nフォーマット: \(formattedQuizArray)\n本番: \(prodQuizContent)\n-----------------------------------------")
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
