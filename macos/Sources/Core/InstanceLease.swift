import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public enum InstanceLeaseError: LocalizedError {
    case busy
    case access(String, Int32)
    public var errorDescription: String? {
        switch self {
        case .busy: return "Приложение уже запущено"
        case .access(let path, let code): return "Нет доступа к \(path): \(String(cString:strerror(code)))"
        }
    }
}

public final class InstanceLease {
    private var descriptor: Int32 = -1
    public let url: URL
    public init(dataRoot: URL) throws {
        url = dataRoot.appendingPathComponent("native.lock")
        try FileManager.default.createDirectory(at:dataRoot,withIntermediateDirectories:true)
        do {
            // Swift needs an explicit octal prefix. 0600 is DECIMAL 600 and
            // previously created a file without owner read/write permissions.
            var handle = open(url.path,O_RDWR | O_CREAT | O_NOFOLLOW | O_CLOEXEC,0o600)
            if handle < 0 && errno == EACCES {
                var old = stat()
                if lstat(url.path,&old) == 0,
                   (old.st_mode & mode_t(S_IFMT)) == mode_t(S_IFREG), old.st_uid == getuid() {
                    // Repair this user's lock in place. Never unlink/replace a
                    // lock inode: an already running client may still hold it.
                    guard chmod(url.path,mode_t(0o600)) == 0 else { throw InstanceLeaseError.access(url.path,errno) }
                    handle = open(url.path,O_RDWR | O_NOFOLLOW | O_CLOEXEC)
                }
            }
            guard handle >= 0 else { throw InstanceLeaseError.access(url.path,errno) }
            descriptor = handle
            var info = stat()
            guard fstat(handle,&info) == 0 else { throw InstanceLeaseError.access(url.path,errno) }
            guard (info.st_mode & mode_t(S_IFMT)) == mode_t(S_IFREG), info.st_uid == getuid() else { throw InstanceLeaseError.access(url.path,EACCES) }
            guard fchmod(handle,mode_t(0o600)) == 0 else { throw InstanceLeaseError.access(url.path,errno) }
            guard flock(handle,LOCK_EX | LOCK_NB) == 0 else {
                let code = errno
                if code == EWOULDBLOCK || code == EAGAIN { throw InstanceLeaseError.busy }
                throw InstanceLeaseError.access(url.path,code)
            }
        } catch { release(); throw error }
    }
    public func release() {
        if descriptor >= 0 { close(descriptor); descriptor = -1 }
        // Closing releases flock; leave the pathname and inode in place.
    }
    deinit { release() }

    public static func checkDataDirectory(_ root: URL) throws {
        try FileManager.default.createDirectory(at:root,withIntermediateDirectories:true)
        let probe = root.appendingPathComponent(".write-check-" + UUID().uuidString)
        defer { try? FileManager.default.removeItem(at:probe) }
        try Data([0]).write(to:probe,options:.withoutOverwriting)
        let settings = root.appendingPathComponent("settings.json")
        var info = stat()
        if lstat(settings.path,&info) == 0 { _ = try Data(contentsOf:settings) }
        else if errno != ENOENT { throw InstanceLeaseError.access(settings.path,errno) }
    }
}
