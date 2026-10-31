import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
@main struct LeaseChecks {
    static func expect(_ condition: Bool, _ message: String) throws {
        if !condition { throw NSError(domain:message,code:1) }
    }
    static func main() throws {
        let fm = FileManager.default, args = CommandLine.arguments
        if args.count > 2 && args[1] == "--permissions" {
            let data = URL(fileURLWithPath:args[2]).appendingPathComponent("data")
            try fm.createDirectory(at:data,withIntermediateDirectories:true)
            let legacy = data.appendingPathComponent("native.lock"), settings = data.appendingPathComponent("settings.json")
            let bytes = Data("{\"profile\":\"keep-me\"}".utf8); try bytes.write(to:settings); try Data().write(to:legacy)
            // Reproduce the released source's DECIMAL 0600 permissions exactly.
            try expect(chmod(legacy.path,mode_t(600)) == 0,"Cannot create permission fixture")
            let check = open(legacy.path,O_RDWR); if check >= 0 { close(check) }
            try expect(check == -1 && errno == EACCES,"Permission fixture did not reproduce EACCES")
            var before = stat(); try expect(lstat(legacy.path,&before) == 0,"Cannot stat fixture")
            let lease = try InstanceLease(dataRoot:data); try InstanceLease.checkDataDirectory(data)
            var after = stat(); try expect(lstat(legacy.path,&after) == 0,"Cannot stat repaired lock")
            try expect(before.st_ino == after.st_ino && (after.st_mode & mode_t(0o7777)) == mode_t(0o600),"Repair replaced inode or used wrong permissions")
            try expect(try Data(contentsOf:settings) == bytes,"Settings were modified")
            lease.release()
            // A bad-mode inode can still be locked by the process that created
            // it. Repairing permissions must not bypass that live owner's lock.
            let owner = open(legacy.path,O_RDWR); try expect(owner >= 0 && flock(owner,LOCK_EX | LOCK_NB) == 0,"Cannot hold legacy lock")
            try expect(chmod(legacy.path,mode_t(600)) == 0,"Cannot set old mode")
            do { _ = try InstanceLease(dataRoot:data); throw NSError(domain:"Live owner bypassed",code:1) }
            catch InstanceLeaseError.busy { }
            close(owner)
            let reopened = try InstanceLease(dataRoot:data); reopened.release()
            print("PASS permissions: decimal-0600 failure reproduced, repaired on same inode, settings retained, live owner respected")
            try fm.setAttributes([.posixPermissions:0o500],ofItemAtPath:data.path)
            defer { try? fm.setAttributes([.posixPermissions:0o700],ofItemAtPath:data.path) }
            do { try InstanceLease.checkDataDirectory(data); throw NSError(domain:"Unwritable folder accepted",code:1) }
            catch let e as NSError { try expect(e.domain != "Unwritable folder accepted","Unwritable folder accepted") }
            print("PASS permissions: unwritable data folder rejected")
            return
        }
        let data = fm.temporaryDirectory.appendingPathComponent("isv-lease-"+UUID().uuidString)
        defer { try? fm.removeItem(at:data) }
        let a = try InstanceLease(dataRoot:data)
        var info = stat(); try expect(lstat(a.url.path,&info) == 0 && (info.st_mode & mode_t(0o7777)) == mode_t(0o600),"New lock is not 0o600")
        do { _ = try InstanceLease(dataRoot:data); throw NSError(domain:"Duplicate accepted",code:1) }
        catch InstanceLeaseError.busy { }
        a.release(); let b = try InstanceLease(dataRoot:data); b.release()
        try expect(fm.fileExists(atPath:b.url.path),"Lock inode removed on release")
        print("PASS lease: correct 0o600, single instance, release/reopen and persistent inode")
        try fm.removeItem(at:b.url); let target = data.appendingPathComponent("untouched")
        let bytes = Data("do-not-touch".utf8); try bytes.write(to:target); try fm.createSymbolicLink(at:b.url,withDestinationURL:target)
        do { _ = try InstanceLease(dataRoot:data); throw NSError(domain:"Symlink accepted",code:1) }
        catch InstanceLeaseError.access { }
        try expect(try Data(contentsOf:target) == bytes,"Symlink target modified")
        print("PASS lease: symlink target untouched")
    }
}
