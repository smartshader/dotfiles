[[ "$OS" != "Darwin" ]] && return 0

info "Configuring macOS defaults..."

_needs_activate=false

# Disable Ctrl+Space (key 60) and Ctrl+Alt+Space (key 61) shortcuts for input
# source switching (conflicts with tmux leader key)
for key in 60 61; do
  enabled=$(defaults export com.apple.symbolichotkeys - | plutil -extract "AppleSymbolicHotKeys.$key.enabled" raw -o - -- - 2>/dev/null)
  if [[ "$enabled" != "false" ]]; then
    _needs_activate=true
    break
  fi
done

if $_needs_activate; then
  info "Disabling Ctrl+Space input source switching shortcuts..."
  # Must use plutil to set correct types (boolean, integer) — defaults write
  # stores everything as strings which macOS ignores
  defaults export com.apple.symbolichotkeys /tmp/symbolichotkeys.plist
  for key in 60 61; do
    plutil -replace "AppleSymbolicHotKeys.$key.enabled" -bool false /tmp/symbolichotkeys.plist
  done
  defaults import com.apple.symbolichotkeys /tmp/symbolichotkeys.plist
  rm -f /tmp/symbolichotkeys.plist
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
fi
