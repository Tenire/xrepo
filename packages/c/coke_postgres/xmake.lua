package("coke_postgres")
    set_homepage("https://github.com/Tenire/coke-postgres")
    set_description("C++20 Coroutine wrapper for wf-postgres based on Coke framework")
    set_license("Apache-2.0")

    add_urls("https://github.com/Tenire/coke-postgres.git")

    add_versions("0.1.1", "f626424dd0b576f41e180b0905550b0a30cb084a")

    add_deps("wf_postgres")
    add_deps("coke")

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
            #include <ckpg/postgres_client.h>
            void test() {
                ckpg::PostgresClientParams params;
            }
        ]]}, {configs = {languages = "c++20"}}))
    end)
package_end()
