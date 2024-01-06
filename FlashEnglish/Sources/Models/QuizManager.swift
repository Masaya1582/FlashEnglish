//
//  QuizManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

enum QuizLevel: String, CaseIterable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
}

final class QuizManager: ObservableObject {
    // MARK: - Properties
    @Published var currentIndex: Int = 0
    @Published var quizIndex: Int = 0
    @Published var correctCount = 0
    @Published var count = 3
    @Published var tryAgainCount = 3
    @Published var answer = ""
    @Published var alertTitle = ""
    @Published var formattedCorrectAnswer = ""
    @Published var isShowResultView = false
    @Published var isShowQuizDetailView = false
    @Published var isShowQuizView = false
    @Published var isSetNextQuiz = false
    @Published var isShowAnswerView = false
    @Published var isTryAgain = false
    @Published var isShowDescriptionModalView = false
    @Published var isAnswerCorrect = false
    @Published var isShowMaruBatsu = false
    @Published var isTryOneMore = false
    @Published var isTryNextQuiz = false
    @Published var allQuizDataArray: [String] = []
    @Published var formattedQuizArray: [String] = []
    @Published var prodQuizContent: [String] = []
    @Published var eachQuizArray: [String] = []
    @Published var quizForRetry: [String] = []
    @Published var userAnswer: [String] = []
    @Published var correctAnswer: [String] = []
    @Published var timer: Timer?
    @Published var quizTimer: Timer?
    @Published var quizLevel: QuizLevel?
    @Published var quizData = QuizData()

    // MARK: - Functions
    func setQuiz(isSetNextQuiz: Bool, quizLevel: QuizLevel) {
        self.quizLevel = quizLevel
        if isSetNextQuiz {
            // 次の問題をセット
            count = 3
            quizIndex = 0
            currentIndex += 1
        } else {
            // 初回読み込み
            quizData.allQuizContents = loadCSV(with: quizLevel.rawValue).shuffled()
        }
        formattedQuizArray = quizData.allQuizContents[currentIndex]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        prodQuizContent = formattedQuizArray
        prodQuizContent.shuffle()
        print("問題番号: \(currentIndex), 全データ: \(quizData.allQuizContents)\nフォーマット: \(formattedQuizArray)\n本番: \(prodQuizContent)\n-----------------------------------------")
    }

    func resetAndRestartQuiz() {
        count = 3
        quizIndex = 0
        prodQuizContent = quizForRetry
    }

    func startTimerForCountDown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.count > 0 {
                self.count -= 1
                if self.count == 0 {
                    self.startTimerForQuiz()
                }
            }
        }
    }

    func startTimerForQuiz() {
        quizTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.quizIndex < (self.isTryAgain ? self.quizForRetry.count : self.prodQuizContent.count) {
                self.quizIndex += 1
            } else {
                self.quizTimer?.invalidate()
                self.quizTimer = nil
                self.correctAnswer = self.formattedQuizArray
                self.isShowAnswerView = true
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        quizTimer?.invalidate()
        timer = nil
        quizTimer = nil
    }

    func judgeAnswer() {
        userAnswer = answer.components(separatedBy: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        isShowMaruBatsu = true
        if userAnswer == correctAnswer {
            isAnswerCorrect = true
            correctCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isShowMaruBatsu = false
            self?.isShowDescriptionModalView = true
        }
    }

    func resetQuiz() {
        isShowDescriptionModalView = false
        isShowAnswerView = false
        isAnswerCorrect = false
        answer = ""
        tryAgainCount = 3
        userAnswer = []
        correctAnswer = []
    }

    func resetAllQuiz() {
        currentIndex = 0
        quizIndex = 0
        correctCount = 0
        isShowResultView = false
        allQuizDataArray = []
        formattedQuizArray = []
        prodQuizContent = []
        isShowQuizDetailView = false
        isShowQuizView = false
        isSetNextQuiz = false
        count = 3
        eachQuizArray = []
        isShowAnswerView = false
        isTryAgain = false
        quizForRetry = []
        tryAgainCount = 3
        answer = ""
        userAnswer = []
        alertTitle = ""
        isShowDescriptionModalView = false
        isAnswerCorrect = false
        isShowMaruBatsu = false
        correctAnswer = []
        isTryOneMore = false
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
