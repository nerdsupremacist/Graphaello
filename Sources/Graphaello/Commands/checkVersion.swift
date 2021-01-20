
import Foundation
import CLIKit

func checkVersion() {
    guard let installed = fetchInstalledVersion(),
          let latest = fetchLatestVersion(),
          installed != latest else { return }

    Console.print(warning: "warning: ⚠️ There's a Graphaello update available (\(latest)). Please update using: brew upgrade graphaello")
}

private struct HomebrewInfo: Decodable {
    struct Versions: Decodable {
        let stable: String
    }

    let versions: Versions
}

private func fetchInstalledVersion() -> String? {
    let task = Process()
    task.launchPath = "/usr/local/bin/brew"
    task.arguments = ["info", "graphaello", "--json"]

    let outputPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = outputPipe

    task.launch()
    task.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    guard let info = try? JSONDecoder().decode([HomebrewInfo].self, from: outputData).first else { return nil }
    return info.versions.stable
}

private struct GitHubRelease: Decodable {
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case assets
    }

    struct Asset: Decodable {
        let url: URL
    }

    let tagName: String
    let assets: [Asset]
}

private func fetchLatestVersion() -> String? {
    let defaults = UserDefaults.standard
    let now = Date()
    if let latestVersion = defaults.string(forKey: "latest-version"),
       let date = defaults.object(forKey: "last-version-check") as? Date,
       now.timeIntervalSince(date) < 2 * 60 * 60 {

        return latestVersion
    }

    var release: GitHubRelease?
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/repos/nerdsupremacist/Graphaello/releases/latest")!) { data, _, _ in
        defer { semaphore.signal() }
        guard let data = data else { return }
        release = try? JSONDecoder().decode(GitHubRelease.self, from: data)
    }
    task.resume()
    _ = semaphore.wait(timeout: .now() + 5)

    if let release = release {
        defaults.set(release.tagName, forKey: "latest-version")
        defaults.set(now, forKey: "last-version-check")
    }

    return release?.tagName
}
