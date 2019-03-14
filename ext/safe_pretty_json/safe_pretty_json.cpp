#include <vector>
#include <ruby.h>
#include "extconf.h"

namespace {

class Prettifier {
public:
    Prettifier(const char *input): input_(input), nest_count_(0) {
        Parse();
    }

    const char *error() const { return error_.size() ? error_.data() : nullptr; }
    const char *output() const { return output_.data(); }
    size_t output_size() const { return output_.size(); }
private:
    void Parse() {
        ParseSpace();
        while (*input_) {
            switch (*input_) {
            case '{':
            case '[':
                Write(*input_);
                input_++;
                ParseSpace();
                // for JSON.pretty_generate compatibility
                if (*input_ == '}') {
                    WriteNewline();
                    WriteIndent();
                    Write(*input_);
                    input_++;
                } else if (*input_ == ']') {
                    WriteNewline();
                    WriteNewline();
                    WriteIndent();
                    Write(*input_);
                    input_++;
                } else {
                    nest_count_++;
                    WriteNewline();
                    WriteIndent();
                }
                break;
            case '}':
            case ']':
                nest_count_--;
                WriteNewline();
                WriteIndent();
                Write(*input_);
                input_++;
                break;
            case ',':
                Write(*input_);
                WriteNewline();
                WriteIndent();
                input_++;
                break;
            case ':':
                Write(*input_);
                WriteSpace();
                input_++;
                break;
            case '"':
                ParseString();
                break;
            default:
                Write(*input_);
                input_++;
                break;
            }
            ParseSpace();
        }
    }

    void ParseSpace() {
        while (*input_) {
            switch (*input_) {
            case ' ':
            case '\f':
            case '\n':
            case '\r':
            case '\t':
            case '\v':
                input_++;
                break;
            default:
                return;
            }
        }
    }

    void ParseString() {
        Write(*input_);
        input_++;
        while (*input_) {
            switch (*input_) {
            case '\\':
                Write(*input_);
                input_++;
                if (*input_) {
                    Write(*input_);
                    input_++;
                }
                break;
            case '"':
                Write(*input_);
                input_++;
                return;
            default:
                Write(*input_);
                input_++;
                break;
            }
        }
    }

    void WriteIndent() {
        for (int i = 0; i < 2 * nest_count_; i++) {
            Write(' ');
        }
    }

    void WriteNewline() {
        Write('\n');
    }

    void WriteSpace() {
        Write(' ');
    }

    void Write(char c) {
        output_.push_back(c);
    }

    const char *input_;
    int nest_count_;
    std::vector<char> error_;
    std::vector<char> output_;
};

VALUE prettify(VALUE _self, VALUE val) {
    Check_Type(val, T_STRING);
    const char *input = StringValueCStr(val);

    Prettifier prettifier(input);
    if (prettifier.error()) {
        rb_raise(rb_eRuntimeError, "%s", prettifier.error());
    }

    return rb_str_new(prettifier.output(), prettifier.output_size());
}

}

extern "C"
void Init_safe_pretty_json() {
    VALUE mod = rb_define_module("SafePrettyJson");
    rb_define_module_function(mod, "prettify", reinterpret_cast<VALUE (*)(...)>(prettify), 1);
}
