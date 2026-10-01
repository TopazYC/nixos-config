{
  config,
  lib,
  pkgs,
  llm-agents,
  ...
}:

{
  home.packages = with pkgs; [
    nodejs_latest
    pnpm

    (llm-agents.packages.${pkgs.system}.dsh.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
              substituteInPlace \
                $out/lib/node_modules/@deepseek-ai/dsh/node_modules/@deepseek-ai/dsh-app-boot/lib/index.js \
                --replace-fail \
              'createRequire(import.meta.url)("node-addon-require-builtin")' \
        '{ requireBuiltin: createRequire(import.meta.url) }'
      '';
    }))
  ];
}
