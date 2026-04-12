#include "Utf8LineReader.h"

#include <cassert>
#include <filesystem>
#include <fstream>
#include <string>
#include <string_view>
#include <vector>

namespace {

std::filesystem::path WriteFile(const std::filesystem::path& path, const std::string& content)
{
    std::ofstream output(path, std::ios::binary);
    output.write(content.data(), static_cast<std::streamsize>(content.size()));
    return path;
}

void ExpectStatus(LineReaderStatus actual, LineReaderStatus expected)
{
    assert(actual == expected);
}

void AT_03_ReadBeforeOpenReturnsNotOpen()
{
    Utf8LineReader reader;
    std::string_view line;

    ExpectStatus(reader.ReadLine(line), LineReaderStatus::not_open);
}

void AT_01_ReadThreeLinesThenEof(const std::filesystem::path& temp_dir)
{
    const auto path = WriteFile(temp_dir / "three_lines.txt", "alpha\nbeta\ngamma\n");

    Utf8LineReader reader;
    std::string_view line;
    std::vector<std::string> observed;

    ExpectStatus(reader.Open(path), LineReaderStatus::ok);
    assert(reader.IsOpen());

    while (reader.ReadLine(line) == LineReaderStatus::ok) {
        observed.emplace_back(line);
    }

    assert(observed.size() == 3);
    assert(observed[0] == "alpha");
    assert(observed[1] == "beta");
    assert(observed[2] == "gamma");
    ExpectStatus(reader.ReadLine(line), LineReaderStatus::end_of_file);
}

void AT_02_EmptyFileReturnsEof(const std::filesystem::path& temp_dir)
{
    const auto path = WriteFile(temp_dir / "empty.txt", "");

    Utf8LineReader reader;
    std::string_view line;

    ExpectStatus(reader.Open(path), LineReaderStatus::ok);
    ExpectStatus(reader.ReadLine(line), LineReaderStatus::end_of_file);
}

void AT_05_ViewMustBeCopiedBeforeNextRead(const std::filesystem::path& temp_dir)
{
    const auto path = WriteFile(temp_dir / "copy_required.txt", "first\nsecond\n");

    Utf8LineReader reader;
    std::string_view line;

    ExpectStatus(reader.Open(path), LineReaderStatus::ok);
    ExpectStatus(reader.ReadLine(line), LineReaderStatus::ok);
    const std::string preserved(line);
    ExpectStatus(reader.ReadLine(line), LineReaderStatus::ok);

    assert(preserved == "first");
    assert(line == "second");
}

}

int main()
{
    const auto temp_dir = std::filesystem::temp_directory_path() / "utf8_line_reader_acceptance";
    std::filesystem::create_directories(temp_dir);

    AT_03_ReadBeforeOpenReturnsNotOpen();
    AT_01_ReadThreeLinesThenEof(temp_dir);
    AT_02_EmptyFileReturnsEof(temp_dir);
    AT_05_ViewMustBeCopiedBeforeNextRead(temp_dir);
}
