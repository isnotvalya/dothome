#!/bin/zsh

PACKAGES=(
  christian-kohler.path-intellisense
  donjayamanne.githistory
  kangping.protobuf
  ms-azuretools.vscode-docker
  ms-python.python
  ms-vscode.Go
  naumovs.color-highlight
  wayou.vscode-todo-highlight
  zhuangtongfa.material-theme
)

VSCODE_USER_SETTINGS=$HOME/Library/Application\ Support/Code/User/settings.json

_code() {
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" $* || exit 1
}

for pkg in $PACKAGES ; do
  _code --install-extension "$pkg"
done

cat <<EOL > $VSCODE_USER_SETTINGS
{
  "workbench.startupEditor": "none",
  "explorer.openEditors.visible": 0,
  "workbench.colorTheme": "Default Light+",
  "editor.renderWhitespace": "all",
  "files.trimTrailingWhitespace": true,
  "files.trimFinalNewlines": true,
  "workbench.editor.tabCloseButton": "off",
  "telemetry.enableTelemetry": false,
  "telemetry.enableCrashReporter": false,
  "go.useLanguageServer": true,
  "editor.minimap.enabled": false,
  "go.formatTool": "goimports",
  "go.goroot": "$HOME/brew/opt/go/libexec"
}
EOL
