//
//  QuizManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

enum QuizLevel: String, CaseIterable {
    case juniorHighSchool = "JuniorHighSchool"
    case hightSchool = "HighSchool"
    case college = "College"
    case businessman = "Businessman"
    case professor = "Professor"
    case monster = "Monster"

    var levelTitle: String {
        switch self {
        case .juniorHighSchool: return "中学生レベル"
        case .hightSchool: return "高校生レベル"
        case .college: return "大学生レベル"
        case .businessman: return "社会人レベル"
        case .professor: return "専門家レベル"
        case .monster: return "人外レベル"
        }
    }
}

final class QuizManager: ObservableObject {
    // MARK: - Properties
    @Published var quizNumber: Int = 0
    @Published var eachQuizWordNumber: Int = 0
    @Published var correctCount = 0
    @Published var countDown = 3
    @Published var tryAgainRemainCount = 3
    @Published var textFieldInputs = ""
    @Published var formattedCorrectAnswer = ""
    @Published var levelTitle = ""
    @Published var isShowQuizDetailView = false
    @Published var isShowQuizView = false
    @Published var isShowAnswerView = false
    @Published var isShowDescriptionModalView = false
    @Published var isShowResultView = false
    @Published var isSetNextQuiz = false
    @Published var isTryAgainTriggered = false
    @Published var isTryNextQuiz = false
    @Published var isAnswerCorrect = false
    @Published var isShowMaruBatsu = false
    @Published var isShowAlert = false
    @Published var isShowHint = false
    @Published var isFlipHint = false
    @Published var allQuizDataArray: [String] = []
    @Published var formattedQuizArray: [String] = []
    @Published var productionQuizContentArray: [String] = []
    @Published var quizContentForTryAgain: [String] = []
    @Published var userAnswer: [String] = []
    @Published var correctAnswer: [String] = []
    @Published var countDownTimer: Timer?
    @Published var quizTimer: Timer?
    @Published var quizLevel: QuizLevel?
    @Published var quizData = QuizData()

    // MARK: - Functions
    func setQuiz(isSetNextQuiz: Bool, quizLevel: QuizLevel) {
        self.quizLevel = quizLevel
        levelTitle = quizLevel.levelTitle
        if isSetNextQuiz {
            // 次の問題をセット
            countDown = 3
            eachQuizWordNumber = 0
            quizNumber += 1
        } else {
            // 初回読み込み
            quizData.allQuizContents = loadCSV(with: quizLevel.rawValue).shuffled()
        }
        formattedQuizArray = quizData.allQuizContents[quizNumber]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        productionQuizContentArray = formattedQuizArray
        productionQuizContentArray.shuffle()
        print("インデックス: \(quizNumber), 全データ: \(quizData.allQuizContents)\nフォーマット: \(formattedQuizArray)\n本番用: \(productionQuizContentArray)\n-----------------------------------------")
    }

    // TryAgain用
    func resetAndRestartQuiz() {
        countDown = 3
        eachQuizWordNumber = 0
        productionQuizContentArray = quizContentForTryAgain
    }

    // カウントダウンタイマー
    func startTimerForCountDown() {
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.countDown > 0 {
                self.countDown -= 1
                if self.countDown == 0 {
                    self.startTimerForQuiz()
                }
            }
        }
    }

    // 英単語フラッシュ表示用タイマー
    func startTimerForQuiz() {
        quizTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.eachQuizWordNumber < (self.isTryAgainTriggered ? self.quizContentForTryAgain.count : self.productionQuizContentArray.count) {
                self.eachQuizWordNumber += 1
            } else {
                self.quizTimer?.invalidate()
                self.quizTimer = nil
                self.correctAnswer = self.formattedQuizArray
                self.isShowAnswerView = true
            }
        }
    }

    // タイマー破棄
    func stopTimer() {
        countDownTimer?.invalidate()
        quizTimer?.invalidate()
        countDownTimer = nil
        quizTimer = nil
    }

    // 正誤判定
    func judgeAnswer() {
        userAnswer = textFieldInputs.components(separatedBy: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        isShowMaruBatsu = true
        if userAnswer == correctAnswer {
            isAnswerCorrect = true
            correctCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isShowMaruBatsu = false
            self?.isShowDescriptionModalView = true
        }
    }

    // 次の問題用にリセット
    func resetQuiz() {
        isShowDescriptionModalView = false
        isShowAnswerView = false
        isAnswerCorrect = false
        // isShowHint = false
        isFlipHint = false
        textFieldInputs = ""
        tryAgainRemainCount = 3
        userAnswer = []
        correctAnswer = []
    }

    // 全てリセット
    func resetAllQuiz() {
        quizNumber = 0
        eachQuizWordNumber = 0
        correctCount = 0
        isShowResultView = false
        allQuizDataArray = []
        formattedQuizArray = []
        productionQuizContentArray = []
        isShowQuizDetailView = false
        isShowQuizView = false
        isSetNextQuiz = false
        isShowHint = false
        isFlipHint = false
        countDown = 3
        isShowAnswerView = false
        isTryAgainTriggered = false
        quizContentForTryAgain = []
        tryAgainRemainCount = 3
        textFieldInputs = ""
        levelTitle = ""
        userAnswer = []
        isShowDescriptionModalView = false
        isAnswerCorrect = false
        isShowMaruBatsu = false
        correctAnswer = []
    }

    func isLevelCompleted(level: String) -> Bool {
        UserDefaults.standard.bool(forKey: "\(level)Completed")
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
