main.bin:main.asm readDisk.asm printf.asm printh.asm testA20.asm enableA20.asm checklm.asm gdt.asm keyboard.asm cmd.asm terminal.asm
	nasm -fbin main.asm -o main.bin
	rm -rf ./build

clean:
	rm main.bin
	rm -rf ./build
	rm -rf disk.img

run:
	qemu-system-x86_64 main.bin -m 512
vbox:
	virtualbox main.iso

i386:
	qemu-system-i386 main.bin -m 512

iso:
	rm -rf ./build
	mkdir build
	truncate main.bin -s 1200k
	cp main.bin ./build
	mkisofs -b main.bin -o ./build/main.iso ./build

imgf12:
	rm -rf ./build
	mkdir build
	truncate main.bin -s 1200k
	cp main.bin ./build
	mkfs.fat -F 12 -i 0x12345678 disk.img
	dd if=./build/main.bin of=disk.img bs=512 conv=notrunc
