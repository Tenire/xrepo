package("maplog")
    set_homepage("https://github.com/Tenire/maplog")
    set_description("Lightweight C++ logging library with file rotation and source location capture")
    set_license("GPL-3.0")

    add_urls("https://github.com/Tenire/maplog.git")

    add_versions("v1.0.1", "7726d604883eee8c6b02ee3851a92c37af7ec741")

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install("linux", "macosx", function (package)
        local configs = {build_examples = false}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <logger.h>
            void test() {
                maplog::Logger::instance().flush();
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
package_end()
