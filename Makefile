PROJECT=foo
CPU ?= cortex-m3
BOARD ?= stm32vldiscovery

# For codespace use below BOARD
# BOARD ?= mps2-an385

qemu:
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c foo.S -o foo.o
	arm-none-eabi-ld -Tmap.ld foo.o -o foo.elf
	arm-none-eabi-objdump -D -S foo.elf > foo.elf.lst
	arm-none-eabi-readelf -a foo.elf > foo.elf.debug
	qemu-system-arm -S -M $(BOARD) -cpu $(CPU) -nographic -kernel $(PROJECT).elf -gdb tcp::1234
	
gdb:
	gdb-multiarch -q $(PROJECT).elf -ex "target remote localhost:1234" -ex "set architecture armv7-m" -ex "layout src" -ex "layout regs"
	
clean:
	rm -rf *.out *.elf .gdb_history *.lst *.debug *.o
	