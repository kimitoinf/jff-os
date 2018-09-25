#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char** argv)
{
	ofstream target;
	ifstream boot;
	ifstream kernel;

	if (argc < 3)
	{
		cout << "argv error" << endl;
		return -1;
	}
	target.open(argv[1], ios::binary | ios::trunc);
	boot.open(argv[2], ios::binary);
	kernel.open(argv[3], ios::binary);
	if(!target.is_open() || !boot.is_open() || !kernel.is_open())
	{
		cout << "file error" << endl;
		return -1;
	}
	boot.seekg(0, ios::end);
	kernel.seekg(0, ios::end);
	target.seekp(0, ios::end);
	int bootsize = boot.tellg();
	int kernelsize = kernel.tellg();
	if (bootsize != 512)
	{
		cout << "boot error" << endl;
		return -1;
	}
	char bootbuf[512];
	char* kernelbuf = new char[kernelsize];
	boot.seekg(0, ios::beg);
	boot.read(bootbuf, bootsize);
	target.write(bootbuf, boot.tellg());
	kernel.seekg(0, ios::beg);
	kernel.read(kernelbuf, kernelsize);
	target.write(kernelbuf, kernel.tellg());
	for (int loop = 0; loop < (512 - (kernel.tellg() % 512)); loop++)
	{
		if ((kernel.tellg() % 512) == 0) break;
		char empty = 0;
		target.write(reinterpret_cast<const char*>(&empty), sizeof(char));
	}
	unsigned short sectors = (unsigned short) ((target.tellp() - boot.tellg()) / 512);
	target.seekp(0, ios::beg);
	target.write(reinterpret_cast<const char*>(&sectors), 2);
	target.seekp(0, ios::end);
	cout << "kernel size : " << kernel.tellg() << ", fill size : " << (512 - (kernel.tellg() % 512)) << ", OS size : " << target.tellp() << endl;
	boot.close();
	kernel.close();
	target.close();
	delete[] kernelbuf;
	return 0;
}