add_rules("mode.debug", "mode.release")

add_requires("workflow")
add_requires("openssl")

target("coke")
    set_kind("$(kind)")
    set_languages("c++20")
    add_files("src/**.cpp")
    add_headerfiles("include/(**)")
    add_includedirs("include", {public = true})
    add_packages("workflow", "openssl")
    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end
