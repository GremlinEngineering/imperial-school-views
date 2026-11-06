// Imperial School Views: offline, eight-voice S-DSP register-stream renderer.
// This driver is MIT; the unmodified blargg DSP core is LGPL-2.1-or-later.
#include "dsp_core/SPC_DSP.h"
#include <fstream>
#include <vector>
#include <cstdint>
#include <cstdio>
#include <cstring>
struct Event { uint32_t sample; uint8_t address,value; };
static uint32_t u32(std::istream& s) { unsigned char b[4];s.read((char*)b,4);return b[0]|b[1]<<8|b[2]<<16|b[3]<<24; }
static void le(std::ostream& out,uint32_t n,int count) {for(int i=0;i<count;i++)out.put((n>>(8*i))&255);}
int main(int argc,char** argv) {
 if(argc!=3){std::fprintf(stderr,"usage: dsp_render register-stream.bin output.wav\n");return 2;}
 std::ifstream in(argv[1],std::ios::binary);char magic[8];in.read(magic,8);if(!in||std::memcmp(magic,"ISVSNES1",8))return 3;
 uint32_t count=u32(in),total=u32(in);std::vector<unsigned char> ram(65536);in.read((char*)ram.data(),ram.size());
 SPC_DSP dsp;dsp.init(ram.data());dsp.reset();std::vector<short> output(total*2+SPC_DSP::extra_size);dsp.set_output(output.data(),total*2+SPC_DSP::extra_size);
 uint32_t current=0;
 for(uint32_t i=0;i<count;i++){uint32_t at=u32(in);int addr=in.get(),value=in.get();if(!in||at<current||at>total)return 4;if(at>current)dsp.run((at-current)*32);current=at;dsp.write(addr,value);}
 dsp.run((total-current)*32);int produced=dsp.sample_count();if(produced!=(int)total*2){std::fprintf(stderr,"unexpected sample count %d\n",produced);return 5;}
 std::ofstream out(argv[2],std::ios::binary);out.write("RIFF",4);le(out,36+total*4,4);out.write("WAVEfmt ",8);le(out,16,4);le(out,1,2);le(out,2,2);le(out,32000,4);le(out,128000,4);le(out,4,2);le(out,16,2);out.write("data",4);le(out,total*4,4);out.write((char*)output.data(),total*4);return out?0:6;
}
