local osys = require("cmake-tools.osys")

return {
  "Civitasv/cmake-tools.nvim",
  opts = {

    cmake_build_directory = function()
      if osys.iswin32 then
        return "build\\${variant:buildType}"
      end
      return "build/${variant:buildType}"
    end,
  },
}
