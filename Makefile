TOOLCHAIN_DIR := ../..
TARGET = bios

NEWBIOS := 0

MEM = s

ifeq ($(NEWBIOS),1)
	ASM_SOURCES = src/newbios.asm
else ifeq ($(FREEBIOS),1)
	ASM_SOURCES = src/freebios.asm
else
	ASM_SOURCES = src/bios.asm
endif

include $(TOOLCHAIN_DIR)/pm.mk
