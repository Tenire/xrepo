package("wfrest")
    set_homepage("https://github.com/wfrest/wfrest")
    set_description("C++ Web Framework REST API based on Sogou Workflow")
    set_license("Apache-2.0")

    add_urls("https://github.com/wfrest/wfrest/archive/refs/tags/$(version).tar.gz",
             "https://github.com/wfrest/wfrest.git")

    add_versions("v0.9.9", "44175d9ff3c0835ec2cc4286d32e040cffa343d8ad664cebd135750c5f3846fb")
    add_versions("v0.9.8", "61de0d3fd998562c54ec7a932c503a766d9f269386b28aa3cc8f8180868f58ad")

    add_deps("workflow", "zlib")
    add_deps("openssl", {system = true})

    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("linux", "macosx", function (package)
        local content = io.readfile("xmake.lua")
        if content then
            -- Exclude test and example to prevent build-dir repo clone & build pollution
            content = content:gsub('includes%s*%b()', 'includes("src")')
            content = content:gsub('add_requires%("workflow"[%s%a%=%,]*%)', 'add_requires("workflow", {configs = {shared = false}})')
            content = content:gsub('add_requires%("zlib"[%s%a%=%,]*%)', 'add_requires("zlib", {system = false, configs = {shared = false}})')
            io.writefile("xmake.lua", content)
        end

        local configs = {}
        local workflow_pkg = package:dep("workflow")
        if workflow_pkg then
            configs.cxflags = "-I" .. workflow_pkg:installdir("include")
            configs.ldflags = "-L" .. workflow_pkg:installdir("lib")
        end

        import("package.tools.xmake").install(package, configs)
        os.cp("src/(**)", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include "wfrest/HttpServer.h"
            void test() {
                wfrest::HttpServer svr;
            }
        ]]}, {configs = {languages = "c++11"}}))
    end)
package_end()
