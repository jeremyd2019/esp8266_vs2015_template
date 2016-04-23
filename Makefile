CC = xtensa-lx106-elf-gcc
CXX = xtensa-lx106-elf-g++
CFLAGS = -D__ets__ -DICACHE_FLASH -I. -mlongcalls -Os -mtext-section-literals -falign-functions=4 -ffunction-sections -fdata-sections
CXXFLAGS = $(CFLAGS) -fno-rtti -fno-exceptions -std=c++11
LDLIBS = -nostdlib -Wl,-static -Wl,--gc-sections -Wl,--start-group -lmain -lnet80211 -lwpa -llwip -lpp -lphy -lcrypto -lcirom -lstdc++irom -lnewlibport -lstdc++port -Wl,--end-group -lgcc
LDFLAGS = -Teagle.app.v6.4096.irom.ld
BOARDOPTS = -ff 40m -fm qio -fs 32m
RM = del

PROJECT = project
OBJS = project.o

all: $(PROJECT)-0x00000.bin

$(PROJECT)-0x00000.bin: $(PROJECT)
	esptool.py elf2image $(BOARDOPTS) $(PROJECT)

$(PROJECT): $(OBJS)
	$(CXX) $(LDFLAGS) -Wl,-Map=$@.map -o $@ $** $(LDLIBS)

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.cpp.o:
	$(CXX) $(CXXFLAGS) -c -o $@ $<

.S.o:
	$(CC) $(CFLAGS) -c -o $@ $<

flash: $(PROJECT)-0x00000.bin
	esptool.py --port COM3 --baud 115200 write_flash $(BOARDOPTS) 0 $(PROJECT)-0x00000.bin 0x10000 $(PROJECT)-0x10000.bin

clean:
	$(RM) $(PROJECT) $(OBJS) $(PROJECT)-0x00000.bin $(PROJECT)-0x10000.bin $(PROJECT).log $(PROJECT).map
