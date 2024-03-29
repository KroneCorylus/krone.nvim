return {
  "norcalli/nvim-colorizer.lua",
  configure = function()
    require("colorizer").setup({
      'tsx'
    })
  end
}
