#ifndef ISV_SAVER_DATA_PATH_H
#define ISV_SAVER_DATA_PATH_H

#include <sys/types.h>
#include <pwd.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

/* Resolve the account's home, not HOME/NSHomeDirectory(), which the screen
 * saver host can redirect to its sandbox. This grants no additional access:
 * all reads are still subject to macOS sandbox, ACL and privacy checks.
 * Returns an owned path; the caller must free it. No files are written. */
static char *ISVCopySaverDataPath(void) {
    const size_t limit = 1024 * 1024;
    long suggested = sysconf(_SC_GETPW_R_SIZE_MAX);
    size_t capacity = suggested > 0 ? (size_t)suggested : 16384;
    if (capacity < 1024) capacity = 1024;
    if (capacity > limit) capacity = limit;
    for (;;) {
        char *buffer = (char *)malloc(capacity);
        if (!buffer) return NULL;
        struct passwd record, *found = NULL;
        int error = getpwuid_r(getuid(), &record, buffer, capacity, &found);
        if (error == ERANGE) {
            free(buffer);
            if (capacity >= limit) { errno = ERANGE; return NULL; }
            capacity = capacity > limit / 2 ? limit : capacity * 2;
            continue;
        }
        if (error || !found || !found->pw_dir || found->pw_dir[0] != '/') {
            free(buffer);
            errno = error ? error : ENOENT;
            return NULL;
        }
        size_t homeLength = strlen(found->pw_dir);
        while (homeLength > 1 && found->pw_dir[homeLength - 1] == '/') homeLength--;
        const char *suffix = "/Library/Application Support/Imperial School Views";
        /* Avoid a double slash for an unusual root-home account. */
        if (homeLength == 1) suffix++;
        size_t suffixLength = strlen(suffix);
        char *path = (char *)malloc(homeLength + suffixLength + 1);
        if (path) {
            memcpy(path, found->pw_dir, homeLength);
            memcpy(path + homeLength, suffix, suffixLength + 1);
        }
        free(buffer);
        return path;
    }
}
#endif
