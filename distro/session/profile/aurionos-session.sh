# AurionOS live/session branding environment.
# This is intentionally cosmetic and does not replace the Lubuntu/LXQt base stack.

case "${DESKTOP_SESSION:-}" in
  Lubuntu|lubuntu|LXQt|lxqt|"")
    export DESKTOP_SESSION="AurionOS"
    ;;
esac

case "${XDG_SESSION_DESKTOP:-}" in
  Lubuntu|lubuntu|LXQt|lxqt|"")
    export XDG_SESSION_DESKTOP="AurionOS"
    ;;
esac

case ":${XDG_CURRENT_DESKTOP:-}:" in
  *:AurionOS:*) ;;
  ::) export XDG_CURRENT_DESKTOP="LXQt:AurionOS" ;;
  *) export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP}:AurionOS" ;;
esac
