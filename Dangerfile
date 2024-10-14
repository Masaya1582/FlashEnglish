# Dangerfile

# Check if the pull request description has been filled
if github.pr_body.length < 10
  fail("PRの説明がありません。なぜこの変更が必要なのか、どういった変更なのかを説明してください。")
end

# Run SwiftLint and check code quality
swiftlint.lint_files inline_mode: true

# Warn if the PR is marked as "Work in Progress"
if github.pr_title.include?("[WIP]")
  warn("PRが 'Work in Progress' 状態です。レビューを受ける準備ができたらタイトルから '[WIP]' を削除してください。")
end

# Warn for large PRs (500+ lines)
if git.lines_of_code > 500
  warn("このPRは大規模な変更（500行以上）を含んでいます。大きな変更は、可能であれば小さなPRに分割してください。")
end

# Warn if Podfile or Podfile.lock is modified
if git.modified_files.include?("Podfile") || git.modified_files.include?("Podfile.lock")
  warn("PodfileまたはPodfile.lockが変更されました。これらの変更は他の開発者に影響を与える可能性があるため、慎重に確認してください。")
end

# Warn if the last commit message is too short
if git.commits.last.message.length < 3
  warn("最後のコミットメッセージが短すぎます。もう少し詳細なメッセージを追加してください。")
end