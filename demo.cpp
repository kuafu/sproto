#include <iostream>
#include <fstream>

bool LoadPbfile(const char* filename, std::string& pb)
{
	std::ifstream ifs(filename, std::ifstream::binary);
	if (!ifs)
		return false;

	ifs.seekg(0, ifs.end);
	int length = ifs.tellg();
	ifs.seekg(0, ifs.beg);
	pb.resize(length, ' ');

	char* begin = &*pb.begin();
	ifs.read(begin, length);
	ifs.close();

	return true;
}

bool SaveMsgfile(const char* filename, const char* msg, size_t len)
{
	std::ofstream ofs(filename, std::ofstream::binary);
	if (!ofs)
		return false;

	ofs.write(msg, len);
	ofs.close();
	return true;
}

int main(int argc, char* argv[])
{
	std::string pb;
	if (!LoadPbfile("addressbook.pb", pb))
	{
		std::cout << "open addressbook.pb failed" << std::endl;
		return -1;
	}


}

