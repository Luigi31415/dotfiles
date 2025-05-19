-- LuaRocks configuration

rocks_trees = {
   { name = "user", root = home .. "/.luarocks" };
   { name = "system", root = "/usr/local" };
}
variables = {
   LUA_DIR = "/opt/homebrew";
   LUA_BINDIR = "/opt/homebrew/bin";
   LUA_VERSION = "5.1";
   LUA = "/opt/homebrew/bin/luajit";
}
