package("wf_postgres")
    set_homepage("https://github.com/Tenire/wf-postgres")
    set_description("Asynchronous PostgreSQL protocol support for Sogou C++ Workflow")
    set_license("Apache-2.0")

    add_urls("https://github.com/Tenire/wf-postgres.git")

    add_versions("0.1.1", "5913aff674f9903cb06f49e9e8bd97dfe72ebf67")

    add_deps("workflow")
    add_deps("openssl3")

    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("linux", "macosx", function (package)
        local configs = {tutorial = false, tests = false}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <WFPostgresConnection.h>
            #include <WFPostgresClient.h>
            void test() {
                wfpg::WFPostgresConnection conn(1);
            }
        ]]}, {configs = {languages = "c++11"}}))
    end)
package_end()
