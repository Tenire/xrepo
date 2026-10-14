package("workflow")
    set_homepage("https://github.com/sogou/workflow")
    set_description("C++ Parallel Computing and Asynchronous Networking Framework")
    set_license("Apache-2.0")

    add_urls("https://github.com/sogou/workflow/archive/refs/tags/$(version).tar.gz",
             "https://github.com/sogou/workflow.git")

    add_versions("v1.1.0", "321152d9c9c1d5d0182c098e631f5ccb23f4675760933930f18395a0bb69fac3")
    add_versions("v1.0.1", "8da09b26e9f138ed98f11e6be7352ae9cc9a1f297135945ccde8a3d997b65508")

    add_deps("openssl", {system = true})

    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("linux", "macosx", function (package)
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
        if os.isdir("_include/workflow") then
            os.cp("_include/workflow", package:installdir("include"))
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <workflow/WFTaskFactory.h>
            #include <workflow/WFFacilities.h>
            void test() {
                WFFacilities::WaitGroup wait_group(1);
            }
        ]]}, {configs = {languages = "c++11"}}))
    end)
package_end()
