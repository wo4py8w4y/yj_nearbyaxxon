/*
 * 2026, Yves Jeanrenaud https://github.com/yjeanrenaud/yj_nearbyglasses
 */
import Foundation
import Combine
/*
 * geters and seters for settings
 */
@MainActor
final class AppSettings: ObservableObject {
    private enum Keys {
        static let rssiThreshold = "rssi_threshold"
        static let cooldownMs = "cooldown_ms"
        static let language = "app_language"
        static let debugEnabled = "debug_enabled"
        static let debugAdvOnly = "debug_advonly"
        static let debugMaxLines = "debug_max_lines"
        static let debugCompanyIDs = "debug_company_ids"
        static let scanFilters = "scan_filters"
        static let scanManufacturerFilters = "scan_manufacturer_filters"
    }

    @Published var rssiThreshold: Int { didSet { save(Keys.rssiThreshold, value: rssiThreshold) } }
    @Published var cooldownMs: Int { didSet { save(Keys.cooldownMs, value: cooldownMs) } }
    @Published var selectedLanguageRaw: String { didSet { save(Keys.language, value: selectedLanguageRaw) } }
    @Published var debugEnabled: Bool { didSet { save(Keys.debugEnabled, value: debugEnabled) } }
    @Published var debugAdvOnly: Bool { didSet { save(Keys.debugAdvOnly, value: debugAdvOnly) } }
    @Published var debugMaxLines: Int { didSet { save(Keys.debugMaxLines, value: debugMaxLines) } }
    @Published var debugCompanyIDsText: String { didSet { save(Keys.debugCompanyIDs, value: debugCompanyIDsText) } }
    @Published var selectedScanFiltersRaw: [String] { didSet { save(Keys.scanFilters, value: selectedScanFiltersRaw) } }
    @Published var selectedManufacturerFiltersRaw: [String] { didSet { save(Keys.scanManufacturerFilters, value: selectedManufacturerFiltersRaw) } }

    init(defaults: UserDefaults = .standard) {
        let storedRSSI = defaults.object(forKey: Keys.rssiThreshold) as? Int ?? Int(defaults.string(forKey: Keys.rssiThreshold) ?? "-75") ?? -75
        let storedCooldown = defaults.object(forKey: Keys.cooldownMs) as? Int ?? Int(defaults.string(forKey: Keys.cooldownMs) ?? "10000") ?? 10_000
        let storedMaxLines = defaults.object(forKey: Keys.debugMaxLines) as? Int ?? Int(defaults.string(forKey: Keys.debugMaxLines) ?? "200") ?? 200

        self.rssiThreshold = min(0, max(-120, storedRSSI))
        self.cooldownMs = min(600_000, max(0, storedCooldown))
        self.selectedLanguageRaw = defaults.string(forKey: Keys.language) ?? AppLanguage.english.rawValue
        self.debugEnabled = defaults.object(forKey: Keys.debugEnabled) as? Bool ?? false
        self.debugAdvOnly = defaults.object(forKey: Keys.debugAdvOnly) as? Bool ?? false
        self.debugMaxLines = min(5000, max(50, storedMaxLines))
        self.debugCompanyIDsText = defaults.string(forKey: Keys.debugCompanyIDs) ?? ""
        let storedScanFilters = defaults.array(forKey: Keys.scanFilters) as? [String]
        let defaultScanFilters = [
            BLEScanner.ScanFilter.companyID.rawValue,
            BLEScanner.ScanFilter.deviceName.rawValue
        ]
        self.selectedScanFiltersRaw = (storedScanFilters?.isEmpty == false) ? (storedScanFilters ?? defaultScanFilters) : defaultScanFilters
        self.selectedManufacturerFiltersRaw = defaults.array(forKey: Keys.scanManufacturerFilters) as? [String] ?? []
    }

    var selectedLanguage: AppLanguage {
        get { AppLanguage(rawValue: selectedLanguageRaw) ?? .english }
        set { selectedLanguageRaw = newValue.rawValue }
    }

    var debugCompanyIDs: Set<Int> {
        debugCompanyIDsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { token -> Int? in
                guard !token.isEmpty else { return nil }
                let lower = token.lowercased()
                if lower.hasPrefix("0x") {
                    return Int(lower.dropFirst(2), radix: 16)
                }
                if lower.allSatisfy({ $0.isNumber }) {
                    return Int(lower, radix: 10)
                }
                return Int(lower, radix: 16)
            }
            .reduce(into: Set<Int>()) { $0.insert($1) }
    }

    var selectedScanFilters: Set<BLEScanner.ScanFilter> {
        let parsed = selectedScanFiltersRaw.compactMap(BLEScanner.ScanFilter.init(rawValue:))
        return parsed.isEmpty ? Set(BLEScanner.ScanFilter.allCases) : Set(parsed)
    }

    var selectedManufacturerFilters: Set<String> {
        Set(selectedManufacturerFiltersRaw.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty })
    }

    func hasScanFilter(_ filter: BLEScanner.ScanFilter) -> Bool {
        selectedScanFilters.contains(filter)
    }

    func setScanFilter(_ filter: BLEScanner.ScanFilter, enabled: Bool) {
        var values = Set(selectedScanFiltersRaw)
        if enabled {
            values.insert(filter.rawValue)
        } else {
            values.remove(filter.rawValue)
            if values.isEmpty {
                values.insert(filter.rawValue)
            }
        }
        selectedScanFiltersRaw = Array(values)
    }

    private func save(_ key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
