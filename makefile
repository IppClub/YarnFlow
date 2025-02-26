# 编译器设置
CXX = g++
CXXFLAGS = -std=c++17 -Wall -fPIC -Wno-deprecated-declarations
INCLUDE_DIRS = -I./src -I$(LUAI)
LDFLAGS = -L$(LUAL) -shared -llua

SRC_FILES = \
	src/ast.cpp \
	src/parser.cpp \
	src/yarnflow/yarn_compiler.cpp \
	src/yarnflow.cpp

TARGET = ./lib/yarnflow.so

all: $(TARGET)

$(TARGET): $(SRC_FILES)
	@mkdir -p $(dir $(TARGET))
	$(CXX) $(CXXFLAGS) $(INCLUDE_DIRS) $(SRC_FILES) $(LDFLAGS) -o $@

clean:
	rm -f $(TARGET)

.PHONY: all clean

