#include <ruby.h>
#include "extconf.h"

namespace {

class Prettifier {
public:
    Prettifier(const char *input): input_(input), nest_count_(0), output_(0), output_size_(0), output_memory_size_(0) {
        Parse();
    }
    ~Prettifier() {
        xfree(output_);
    }

    const char *output() const { return output_; }
    size_t output_size() const { return output_size_; }
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
        // http://clalance.blogspot.com/2011/01/writing-ruby-extensions-in-c-part-12.html
        if (output_size_ == output_memory_size_) {
            output_memory_size_ = 2 * output_memory_size_ + 1024;
            REALLOC_N(output_, char, output_memory_size_);
        }
        if (output_) {
            output_[output_size_] = c;
            output_size_++;
        } else {
            output_size_ = 0;
        }
    }

    const char *input_;
    int nest_count_;
    char *output_;
    size_t output_size_;
    size_t output_memory_size_;
};

VALUE prettify(VALUE _self, VALUE val) {
    const char *input = StringValueCStr(val);
    Prettifier prettifier(input);
    return rb_str_new(prettifier.output(), prettifier.output_size());
}

}

extern "C"
void Init_safe_pretty_json() {
    VALUE mod = rb_define_module("SafePrettyJson");
    rb_define_module_function(mod, "prettify", reinterpret_cast<VALUE (*)(...)>(prettify), 1);
}
