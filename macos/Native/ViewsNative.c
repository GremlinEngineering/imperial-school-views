#include "include/ViewsNative.h"
#include <brotli/decode.h>
#include <zlib.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <ctype.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#if __APPLE__
#include <CommonCrypto/CommonDigest.h>
#define HASH_CTX CC_SHA256_CTX
#define HASH_INIT CC_SHA256_Init
#define HASH_UPDATE CC_SHA256_Update
#define HASH_FINAL CC_SHA256_Final
#else
#include <openssl/sha.h>
#define HASH_CTX SHA256_CTX
#define HASH_INIT SHA256_Init
#define HASH_UPDATE SHA256_Update
#define HASH_FINAL SHA256_Final
#endif
static int layer(const uint8_t *in,size_t n,uint8_t **out,size_t *length,size_t cap,int br){
 uint8_t *p=malloc(cap+1);if(!p)return 0;size_t size=0;int ok=0;
 if(br){BrotliDecoderState *s=BrotliDecoderCreateInstance(NULL,NULL,NULL);if(s){size_t ai=n,ao=cap+1;const uint8_t *ni=in;uint8_t *no=p;BrotliDecoderResult r=BrotliDecoderDecompressStream(s,&ai,&ni,&ao,&no,&size);ok=r==BROTLI_DECODER_RESULT_SUCCESS&&ai==0&&size<=cap;BrotliDecoderDestroyInstance(s);}}
 else {z_stream s;memset(&s,0,sizeof(s));s.next_in=(Bytef*)in;s.avail_in=(uInt)n;s.next_out=p;s.avail_out=(uInt)(cap+1);if(inflateInit2(&s,31)==Z_OK){int r=inflate(&s,Z_FINISH);size=s.total_out;ok=r==Z_STREAM_END&&s.avail_in==0&&size<=cap;inflateEnd(&s);}}
 if(!ok){free(p);return 0;}*out=p;*length=size;return 1;
}
int ISVDecode(const uint8_t *input,size_t length,const char *encoding,int sidecar,size_t limit,uint8_t **output,size_t *outLength){
 if(!input||!length||!limit||limit>5000000||length>limit||!encoding||strlen(encoding)>128)return 0;
 char enc[129];strcpy(enc,encoding);int layers[3],count=0,hasbr=0;char *ctx=NULL;
 for(char *p=strtok_r(enc,",",&ctx);p;p=strtok_r(NULL,",",&ctx)){while(isspace((unsigned char)*p))p++;size_t n=strlen(p);while(n&&isspace((unsigned char)p[n-1]))p[--n]=0;if(!*p||!strcasecmp(p,"identity"))continue;if(count==2)return 0;if(!strcasecmp(p,"br")){layers[count++]=1;hasbr=1;}else if(!strcasecmp(p,"gzip"))layers[count++]=0;else return 0;}
 for(int i=0;i<count/2;i++){int t=layers[i];layers[i]=layers[count-1-i];layers[count-1-i]=t;}if(sidecar&&!hasbr)layers[count++]=1;
 uint8_t *current=malloc(length);if(!current)return 0;memcpy(current,input,length);
 for(int i=0;i<count;i++){uint8_t *next=NULL;size_t size=0;if(!layer(current,length,&next,&size,limit,layers[i])){free(current);return 0;}free(current);current=next;length=size;}
 if(!length){free(current);return 0;}*output=current;*outLength=length;return 1;
}
static void hex(const uint8_t *p,char *out){const char *digits="0123456789abcdef";for(int i=0;i<32;i++){out[i*2]=digits[p[i]>>4];out[i*2+1]=digits[p[i]&15];}out[64]=0;}
void ISVHashData(const uint8_t *data,size_t length,char out[65]){HASH_CTX ctx;HASH_INIT(&ctx);while(length){size_t n=length>1048576?1048576:length;HASH_UPDATE(&ctx,data,(unsigned)n);data+=n;length-=n;}uint8_t digest[32];HASH_FINAL(digest,&ctx);hex(digest,out);}
int ISVHashFile(const char *path,char out[65]){int fd=open(path,O_RDONLY|O_NOFOLLOW);struct stat st;if(fd<0)return 0;if(fstat(fd,&st)||!S_ISREG(st.st_mode)){close(fd);return 0;}HASH_CTX ctx;HASH_INIT(&ctx);uint8_t buffer[65536];ssize_t n;while((n=read(fd,buffer,sizeof(buffer)))>0)HASH_UPDATE(&ctx,buffer,(unsigned)n);close(fd);if(n<0)return 0;uint8_t digest[32];HASH_FINAL(digest,&ctx);hex(digest,out);return 1;}
void ISVFree(void *p){free(p);}
int ISVPublishFile(const char *source,const char *destination){return rename(source,destination)==0;}
