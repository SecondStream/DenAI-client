#ifndef FLAT_JSON_PARSER_H
#define FLAT_JSON_PARSER_H

#include <string>
#include <map>
#include <cctype>
#include <stdexcept>

class FlatJsonParser {
private:
    std::string json;
    size_t pos = 0;

    void skip_whitespace() {
        while (pos < json.size() && std::isspace(static_cast<unsigned char>(json[pos]))) {
            pos++;
        }
    }

    std::string parse_string() {
        skip_whitespace();
        if (pos < json.size() && json[pos] == '"') pos++;
        size_t start = pos;
        while (pos < json.size() && json[pos] != '"') {
            if (json[pos] == '\\') pos++; 
            pos++;
        }
        std::string res = json.substr(start, pos - start);
        if (pos < json.size() && json[pos] == '"') pos++;
        return res;
    }

    std::string parse_raw_value() {
        skip_whitespace();
        size_t start = pos;
        while (pos < json.size() && json[pos] != ',' && json[pos] != '}') {
            pos++;
        }
        size_t end = pos;
        while (end > start && std::isspace(static_cast<unsigned char>(json[end - 1]))) {
            end--;
        }
        return json.substr(start, end - start);
    }

public:
    explicit FlatJsonParser(std::string src) : json(std::move(src)) {}

    std::map<std::string, std::string> parse() {
        std::map<std::string, std::string> result;
        pos = 0;
        
        skip_whitespace();
        if (pos < json.size() && json[pos] == '{') pos++;

        while (pos < json.size()) {
            skip_whitespace();
            if (pos >= json.size() || json[pos] == '}') break;

            std::string key = parse_string();

            skip_whitespace();
            if (pos < json.size() && json[pos] == ':') pos++;

            skip_whitespace();
            std::string value;
            if (pos < json.size() && json[pos] == '"') {
                value = parse_string();
            } else {
                value = parse_raw_value();
            }

            result[key] = value;

            skip_whitespace();
            if (pos < json.size() && json[pos] == ',') {
                pos++;
            }
        }
        return result;
    }
};

#endif
