//
//  QuizManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  

import SwiftUI

enum QuizLevel: String, CaseIterable {
    case juniorHighSchool = "JuniorHighSchool"
    case highSchool = "HighSchool"
    case college = "College"
    case businessman = "Businessman"
    case expert = "Expert"
    case monster = "Monster"

    var levelTitle: String {
        switch self {
        case .juniorHighSchool: return "中学生レベル"
        case .highSchool: return "高校生レベル"
        case .college: return "大学生レベル"
        case .businessman: return "社会人レベル"
        case .expert: return "専門家レベル"
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
    @Published var tryAgainRemainCount = 2
    @Published var textFieldInputs = ""
    @Published var formattedCorrectAnswer = ""
    @Published var levelTitle = ""
    @Published var isShowQuizDetailView = false
    @Published var isShowQuizView = false
    @Published var isShowAnswerView = false
    @Published var isShowDescriptionModalView = false
    @Published var isShowScoreView = false
    @Published var isSetNextQuiz = false
    @Published var isTryAgainTriggered = false
    @Published var isTryNextQuiz = false
    @Published var isAnswerCorrect = false
    @Published var isShowMaruBatsu = false
    @Published var isShowAlert = false
    @Published var isShowHint = false
    @Published var isFlipHint = false
    @Published var isShowPerfectAnimation = false
    @Published var isShowAllQuizData = false
    @Published var isQuizDataShuffled = false
    @Published var formattedQuizArray: [String] = []
    @Published var productionQuizContentArray: [String] = []
    @Published var quizContentForTryAgain: [String] = []
    @Published var userAnswer: [String] = []
    @Published var correctAnswer: [String] = []
    @Published var quizDataForScoreView: [String] = []
    @Published var countDownTimer: Timer?
    @Published var quizTimer: Timer?
    @Published var quizLevel: QuizLevel?
    @Published var quizData = QuizData()

    // MARK: - Functions

    func loadQuizData(quizLevel: QuizLevel) {
        quizData.allQuizContents = loadCSV(with: quizLevel.rawValue).shuffled()
        levelTitle = quizLevel.levelTitle
    }

    func setQuiz() {
        if isSetNextQuiz {
            quizNumber += 1
        }
        formattedQuizArray = quizData.allQuizContents[quizNumber]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if !isSetNextQuiz {
            for content in quizData.allQuizContents {
                let processedContent = content
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .joined(separator: " ")
                quizDataForScoreView.append(processedContent)
            }
        }
        productionQuizContentArray = formattedQuizArray
        if isQuizDataShuffled {
            productionQuizContentArray.shuffle()
        }
        print("インデックス: \(quizNumber), 全データ: \(quizData.allQuizContents)\nフォーマット: \(formattedQuizArray)\n本番用: \(productionQuizContentArray)\n-----------------------------------------")
    }

    // TryAgain用
    func resetAndRestartQuiz() {
        productionQuizContentArray = quizContentForTryAgain
    }

    // カウントダウンタイマー
    func startTimerForCountDown() {
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.countDown > 0 {
                self.countDown -= 1
                if self.countDown == 0 {
                    self.countDownTimer?.invalidate()
                    self.countDownTimer = nil
                    self.startTimerForQuiz()
                }
            }
        }
    }

    // 英単語フラッシュ表示用タイマー
    func startTimerForQuiz() {
        quizTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
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

    // 正誤判定
    func judgeAnswer() {
        userAnswer = textFieldInputs.components(separatedBy: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        isShowMaruBatsu = true
        if userAnswer == correctAnswer {
            isAnswerCorrect = true
            correctCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isShowMaruBatsu = false
            self.isShowDescriptionModalView = true
        }
    }

    // カウントリセット
    func resetCount() {
        countDown = 3
        eachQuizWordNumber = 0
        // TryAgain用に今の問題を残しておく
        quizContentForTryAgain = productionQuizContentArray
        if isTryAgainTriggered {
            isTryAgainTriggered = false
        }
    }

    // 次の問題用にリセット
    func resetQuiz() {
        isShowDescriptionModalView = false
        isShowAnswerView = false
        isAnswerCorrect = false
        isFlipHint = false
        textFieldInputs = ""
        tryAgainRemainCount = 2
        userAnswer = []
        correctAnswer = []
    }

    // 全てリセット
    func resetAllQuiz() {
        quizNumber = 0
        eachQuizWordNumber = 0
        correctCount = 0
        countDown = 3
        tryAgainRemainCount = 2
        textFieldInputs = ""
        formattedCorrectAnswer = ""
        levelTitle = ""
        isShowQuizDetailView = false
        isShowQuizView = false
        isShowAnswerView = false
        isShowDescriptionModalView = false
        isShowScoreView = false
        isSetNextQuiz = false
        isTryAgainTriggered = false
        isTryNextQuiz = false
        isAnswerCorrect = false
        isShowMaruBatsu = false
        isShowAlert = false
        isShowHint = false
        isFlipHint = false
        isShowPerfectAnimation = false
        isShowAllQuizData = false
        isQuizDataShuffled = false
        formattedQuizArray = []
        productionQuizContentArray = []
        quizContentForTryAgain = []
        userAnswer = []
        correctAnswer = []
        quizDataForScoreView = []
        countDownTimer?.invalidate()
        quizTimer?.invalidate()
        countDownTimer = nil
        quizTimer = nil
        quizLevel = nil
        quizData = QuizData()
    }

    func isLevelCompleted(level: String) -> Bool {
        UserDefaults.standard.bool(forKey: "\(level)Completed")
    }

    private func takeAllScreenShot() -> UIImage {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let size = window?.bounds.size ?? UIScreen.main.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        window?.drawHierarchy(in: window?.bounds ?? .zero, afterScreenUpdates: true)
        guard let screenShotImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("スクショ取得失敗")
        }
        UIGraphicsEndImageContext()
        return screenShotImage
    }

    func shareApp(shareText: String) {
        let image = takeAllScreenShot()
        let items = [shareText, image] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let windowscene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController = windowscene?.windows.first?.rootViewController
        rootViewController?.present(activityViewController, animated: true)
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
