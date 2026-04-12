#pragma once

#include <filesystem>
#include <string_view>

enum class LineReaderStatus {
    ok,
    end_of_file,
    not_open,
    invalid_utf8,
    io_error
};

class Utf8LineReader {
public:
    Utf8LineReader() noexcept;
    ~Utf8LineReader() noexcept;

    Utf8LineReader(const Utf8LineReader&) = delete;
    Utf8LineReader& operator=(const Utf8LineReader&) = delete;
    Utf8LineReader(Utf8LineReader&&) noexcept;
    Utf8LineReader& operator=(Utf8LineReader&&) noexcept;

    [[nodiscard]] LineReaderStatus Open(const std::filesystem::path& path) noexcept;
    [[nodiscard]] LineReaderStatus ReadLine(std::string_view& out_line) noexcept;
    void Close() noexcept;
    [[nodiscard]] bool IsOpen() const noexcept;
};
