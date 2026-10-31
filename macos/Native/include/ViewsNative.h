#ifndef VIEWS_NATIVE_H
#define VIEWS_NATIVE_H
#include <stddef.h>
#include <stdint.h>
int ISVDecode(const uint8_t *input, size_t length, const char *encoding, int sidecar, size_t limit, uint8_t **output, size_t *outLength);
int ISVHashFile(const char *path, char output[65]);
void ISVHashData(const uint8_t *data, size_t length, char output[65]);
void ISVFree(void *data);
int ISVPublishFile(const char *source, const char *destination);
#endif
