package("kale")
    set_homepage("https://github.com/Tenire/kale")
    set_description("Modern C++20 Coroutine Web Framework based on Workflow and Coke")
    set_license("Apache-2.0")

    add_urls("https://github.com/Tenire/kale.git")

    add_versions("0.1.0", "c0fa37ae3cac53c3e8373e1fa2943205298168e4")

    add_versions("0.1.0-dev", "dev")

    add_deps("workflow-ws", "coke")
    add_deps("openssl3")
    add_deps("zlib", "zstd")
    add_links("kale_client", "kale_security", "kale_http", "kale_core")

    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("linux", "macosx", function (package)
        local content = io.readfile("xmake.lua")
        if content then
            content = content:gsub('includes%("tests"%)', '')
            content = content:gsub('includes%("examples"%)', '')
            io.writefile("xmake.lua", content)
        end

        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include "kale/core/http_server.h"
            void test() {
                kale::HttpServer server;
            }
        ]]}, {configs = {languages = "c++20"}}))
    end)
package_end()
