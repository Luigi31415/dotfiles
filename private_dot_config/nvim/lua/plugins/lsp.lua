-- return {
--   "neovim/nvim-lspconfig",
--   opts = function(_, opts)
--     -- Ensure servers table exists
--     opts.servers = opts.servers or {}
--
--     -- Add/modify existing LSP servers
--     opts.servers.ruff = {
--       cmd_env = { RUFF_TRACE = "messages" },
--       init_options = {
--         settings = {
--           logLevel = "error",
--         },
--       },
--       keys = {},
--     }
--
--     opts.servers.ruff_lsp = {
--       keys = {},
--     }
--
--     opts.servers.svelte = {
--       keys = {
--         {
--           "<leader>co",
--           LazyVim.lsp.action["source.organizeImports"],
--           desc = "Organize Imports",
--         },
--       },
--       capabilities = {
--         workspace = {
--           didChangeWatchedFiles = vim.fn.has("nvim-0.10") == 0 and { dynamicRegistration = true },
--         },
--       },
--     }
--
--     opts.servers.vtsls = opts.servers.vtsls or {}
--     LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
--       {
--         name = "typescript-svelte-plugin",
--         location = LazyVim.get_pkg_path("svelte-language-server", "/node_modules/typescript-svelte-plugin"),
--         enableForWorkspaceTypeScriptVersions = true,
--       },
--     })
--
--     -- Setup function for ruff LSP
--     opts.setup = opts.setup or {}
--     opts.setup["ruff"] = function()
--       LazyVim.lsp.on_attach(function(client, bufnr)
--         -- Disable hover in favor of Pyright
--         client.server_capabilities.hoverProvider = false
--       end, "ruff")
--     end
--   end,
-- }

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Ensure required tables exist
    opts.servers = opts.servers or {}
    opts.setup = opts.setup or {}

    ------------------------------------------------------------------------------
    -- LSP Server Configurations
    ------------------------------------------------------------------------------

    -- Ruff LSP configuration
    opts.servers.ruff = {
      cmd_env = { RUFF_TRACE = "messages" },
      init_options = {
        settings = {
          logLevel = "error",
        },
      },
      keys = {},
    }

    -- Alternate Ruff LSP configuration
    opts.servers.ruff_lsp = {
      keys = {},
    }

    -- Svelte LSP configuration
    opts.servers.svelte = {
      keys = {
        {
          "<leader>co",
          LazyVim.lsp.action["source.organizeImports"],
          desc = "Organize Imports",
        },
      },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = vim.fn.has("nvim-0.10") == 0 and { dynamicRegistration = true },
        },
      },
    }

    -- Deprecated tsserver and ts_ls settings (kept disabled)
    opts.servers.tsserver = { enabled = false }
    opts.servers.ts_ls = { enabled = false }

    -- VTSLS configuration: merge settings and filetypes with additional settings from second snippet
    opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      settings = vim.tbl_deep_extend("force", opts.servers.vtsls and opts.servers.vtsls.settings or {}, {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            maxInlayHintLength = 30,
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      }),
      keys = {
        {
          "gD",
          function()
            local params = vim.lsp.util.make_position_params()
            LazyVim.lsp.execute({
              command = "typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
              open = true,
            })
          end,
          desc = "Goto Source Definition",
        },
        {
          "gR",
          function()
            LazyVim.lsp.execute({
              command = "typescript.findAllFileReferences",
              arguments = { vim.uri_from_bufnr(0) },
              open = true,
            })
          end,
          desc = "File References",
        },
        {
          "<leader>co",
          LazyVim.lsp.action["source.organizeImports"],
          desc = "Organize Imports",
        },
        {
          "<leader>cM",
          LazyVim.lsp.action["source.addMissingImports.ts"],
          desc = "Add missing imports",
        },
        {
          "<leader>cu",
          LazyVim.lsp.action["source.removeUnused.ts"],
          desc = "Remove unused imports",
        },
        {
          "<leader>cD",
          LazyVim.lsp.action["source.fixAll.ts"],
          desc = "Fix all diagnostics",
        },
        {
          "<leader>cV",
          function()
            LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
          end,
          desc = "Select TS workspace version",
        },
      },
    })

    -- Extend vtsls configuration with the typescript-svelte-plugin global plugin
    LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
      {
        name = "typescript-svelte-plugin",
        location = LazyVim.get_pkg_path("svelte-language-server", "/node_modules/typescript-svelte-plugin"),
        enableForWorkspaceTypeScriptVersions = true,
      },
    })

    ------------------------------------------------------------------------------
    -- LSP Setup Functions
    ------------------------------------------------------------------------------

    -- Setup for ruff LSP: disable hover (in favor of Pyright)
    opts.setup.ruff = function()
      LazyVim.lsp.on_attach(function(client, bufnr)
        client.server_capabilities.hoverProvider = false
      end, "ruff")
    end

    -- Setup for tsserver and ts_ls (deprecated, kept disabled)
    opts.setup.tsserver = function()
      return true
    end

    opts.setup.ts_ls = function()
      return true
    end

    -- Setup for vtsls: add move-to-file refactoring and copy TypeScript settings to JavaScript
    opts.setup.vtsls = function(_, vtsls_opts)
      LazyVim.lsp.on_attach(function(client, buffer)
        client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
          local action, uri, range = unpack(command.arguments)

          local function move(newf)
            client.request("workspace/executeCommand", {
              command = command.command,
              arguments = { action, uri, range, newf },
            })
          end

          local fname = vim.uri_to_fname(uri)
          client.request("workspace/executeCommand", {
            command = "typescript.tsserverRequest",
            arguments = {
              "getMoveToRefactoringFileSuggestions",
              {
                file = fname,
                startLine = range.start.line + 1,
                startOffset = range.start.character + 1,
                endLine = range["end"].line + 1,
                endOffset = range["end"].character + 1,
              },
            },
          }, function(_, result)
            local files = result.body.files
            table.insert(files, 1, "Enter new path...")
            vim.ui.select(files, {
              prompt = "Select move destination:",
              format_item = function(f)
                return vim.fn.fnamemodify(f, ":~:.")
              end,
            }, function(f)
              if f and f:find("^Enter new path") then
                vim.ui.input({
                  prompt = "Enter move destination:",
                  default = vim.fn.fnamemodify(fname, ":h") .. "/",
                  completion = "file",
                }, function(newf)
                  return newf and move(newf)
                end)
              elseif f then
                move(f)
              end
            end)
          end)
        end
      end, "vtsls")

      -- Copy TypeScript settings to JavaScript settings
      vtsls_opts.settings.javascript =
        vim.tbl_deep_extend("force", {}, vtsls_opts.settings.typescript, vtsls_opts.settings.javascript or {})
    end
  end,
}
