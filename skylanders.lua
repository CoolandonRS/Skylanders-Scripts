local getopt = require('getopt')
local ansicolors = require('ansicolors')
local lib14a = require('read14a')

--help

local copyright = ''
local usage = 'script run dump_skylander -n name'
local author = 'CoolandonRS'
local version = 'v1.0.0'
local desc = [[
  Does all the fancy steps to dump a skylander to a bin file or write a bin file to a magic card
]]
local example = [[
  script run skylanders -d -n starcast
  script run skylanders -c -n starcast
  script run skylanders -e -n starcast
]]
local usage = [[
  script run dump_skylander -d -n <txt>
]]
local arguments = [[
    -h         This help
    -n <txt>   Name of file to write/read to
    -d         Dump mode
    -c         Convert mode (NYI)
    -e         Edit mode (NYI)
]]

local function help()
    print(copyright)
    print(usage)
    print(author)
    print(version)
    print(desc)
    print(ansicolors.cyan..'Usage'..ansicolors.reset)
    print(usage)
    print(ansicolors.cyan..'Arguments'..ansicolors.reset)
    print(arguments)
    print(ansicolors.cyan..'Example usage'..ansicolors.reset)
    print(example)
end

-- program

local function dump(name)
    local result, error = lib14a.read(true)
    if not result then
        print('ERROR: '..error)
        return nil
    end
    local uid = result.uid
    lib14a.disconnect()

    local keyFileName = name..".dic"
    core.console("script run skylanders_util -m genkeys -u "..result.uid.." -o "..keyFileName)

    core.console("hf mf chk --dump -f "..keyFileName)
    os.rename("hf-mf-"..uid.."-key.bin", name.."-key.bin")

    core.console("hf mf dump -f "..name..".bin --keys "..name.."-key.bin")

    print("\nDumped to "..name..".bin!")
end

local mode_UNKNOWN = 0
local mode_DUMP = 1
local mode_CONVERT = 2
local mode_EDIT = 4

local function main(args)
    local name = ""
    local mode = mode_UNKNOWN
    for o, a in getopt.getopt(args, 'hn:dce') do
        if o == 'h' then return help() end
        if o == 'n' then name = a end
        if o == 'd' then mode = mode + mode_DUMP end
        if o == 'c' then mode = mode + mode_CONVERT end
        if o == 'e' then mode = mode + mode_EDIT end
    end
    if mode == mode_UNKNOWN then
        print('ERROR: no mode selected. Try -h')
        return nil
    end

    if mode == mode_DUMP then
        dump(name)
    elseif mode == mode_CONVERT then
        -- Convert unkeyed files to keyed according to https://codesandbox.io/p/sandbox/rbkev?file=%252Findex.js
        print("NOT YET IMPLEMENTED")
    elseif mode == mode_EDIT then
        -- allow editing (probably by saving/loading json to binary) according to the section Cryptography and below at https://marijnkneppers.dev/posts/reverse-engineering-skylanders-toys-to-life-mechanics/
        print("NOT YET IMPLEMENTED")
    else
        print("ERROR: Multiple modes selected")
        return nil
    end
end

---@diagnostic disable-next-line: undefined-global
main(args)