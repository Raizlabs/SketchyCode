import Darwin
import Foundation

/// :nodoc:
public enum Log {
    
    public enum Level: Int {
        case errors
        case warnings
        case verbose
    }
    
    public static var level: Level = .warnings
    
    public static func error(_ message: Any) {
        log(level: .errors, "error: \(message)")
        // to return error when running swift templates which is done in a different process
        if ProcessInfo().processName == "bin" {
            fputs("\(message)", stderr)
        }
    }
    
    public static func warning(_ message: Any) {
        log(level: .warnings, "warning: \(message)")
    }
    
    public static func info(_ message: Any) {
        log(level: .verbose, message)
    }
    
    private static func log(level logLevel: Level, _ message: Any) {
        guard logLevel.rawValue <= Log.level.rawValue else { return }
        print(message)
    }
    
}
