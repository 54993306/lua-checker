LUA_INCLUDE_DIR = -Ilua/src
LUA_LIB = lua/src/liblua.a

APPS=lua_simplifier lua_checker

GENERATED_FILES=lua_lexxer.cc  lua_parser.cc  lua_parser.h lua_checker_parser.cc lua_checker_parser.h

CFLAGS=-Wall -g $(LUA_INCLUDE_DIR) -MMD

all: $(APPS)

lua_simplifier: lua_simplifier.o lua_lexxer.o lua_parser.o util.o
	g++ $(CFLAGS) -o $@ $(OBJS) $^ $(LUA_LIB)

lua_checker: lua_checker.o lua_lexxer.o lua_checker_parser.o util.o
	g++ $(CFLAGS) -o $@ $(OBJS) $^ $(LUA_LIB)

%.o: %.cc
	g++ -c $(CFLAGS) $<

lua_lexxer.cc: lua.lex
	flex -s -8 --bison-bridge --bison-locations $<
	mv lex.yy.c $@

lua_parser.cc lua_parser.h: lua.y
	bison --defines=lua_parser.h $< -o lua_parser.cc

lua_checker_parser.cc lua_checker_parser.h: lua_checker.y
	bison --defines=lua_checker_parser.h $< -o lua_checker_parser.cc

clean:
	rm -f *.o *.d $(GENERATED_FILES) $(APPS)

lua_simplifier.o: lua_parser.h
lua_checker.o: lua_checker_parser.h

-include *.d
