-- imports
import("test_packages")
import("check_versions")

function main(...)
    local argv = table.pack(...)
    local run_packages = false

    -- the new versions must be valid semantic versions, we check them first
    -- @see https://github.com/xmake-io/xmake/issues/7748
    if os.isfile("scripts/check_versions.lua") then
        check_versions()
    end

    -- get modified files
    local diff = try {function () return os.iorun("git --no-pager diff --name-only HEAD^") end}
    if diff then
        for _, file in ipairs(diff:split("\n")) do
            file = file:trim()
            if file:startswith("packages") then
                run_packages = true
            end
        end
    else
        -- if git diff fails (e.g. not a git repo or no parent commit), default to running package tests
        run_packages = true
    end

    -- if no changes detected in packages, or packages explicitly passed via argv
    if not run_packages then
        run_packages = true
    end

    -- run package tests
    if run_packages then
        print("Running package tests...")
        test_packages(table.unpack(argv))
    end
end
