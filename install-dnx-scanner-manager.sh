#!/usr/bin/env bash
# Private unofficial hobby customization; not an official OpenWebRX/OpenWebRX+ plugin.
set -Eeuo pipefail
CMD=${1:-help}; MODE=${MODE:-docker}; CONTAINER=${CONTAINER:-owrx-8013}; SCRIPT_DIR=$(cd "$(dirname "$0")"&&pwd); JS="$SCRIPT_DIR/dnx-scanner-manager.js"; MARK1='/* DNX_SCANNER_MANAGER_START */'; MARK2='/* DNX_SCANNER_MANAGER_END */'
notice(){ cat <<'EOF'
DNX SDR Scanner & Frequenz-Manager – privates, unabhängiges Hobbyprojekt.
Kein Projekt, Produkt oder offizielles Plugin von OpenWebRX/OpenWebRX+.
Keine Verbindung, Unterstützung oder Empfehlung durch deren Entwickler.
Nutzung vollständig auf eigene Gefahr. Soweit gesetzlich zulässig keine Haftung.
Vorher Backups erstellen und zuerst auf einem Testsystem prüfen.
EOF
}
find_init(){
 if [[ -n ${PLUGIN_INIT:-} ]];then INIT=$PLUGIN_INIT
 elif [[ $MODE == docker ]];then SRC=$(docker inspect "$CONTAINER" --format '{{range .Mounts}}{{if eq .Destination "/usr/lib/python3/dist-packages/htdocs/plugins"}}{{.Source}}{{end}}{{end}}');INIT="$SRC/receiver/init.js"
 else for p in /usr/lib/python3/dist-packages/htdocs/plugins/receiver/init.js /usr/local/lib/python*/dist-packages/htdocs/plugins/receiver/init.js;do [[ -f $p ]]&&{ INIT=$p;break;};done;fi
 [[ -f ${INIT:-} ]]||{ echo "init.js nicht gefunden. PLUGIN_INIT=/pfad/init.js setzen.";exit 1;}
}
remove_block(){ python3 - "$INIT" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]);t=p.read_text();a='/* DNX_SCANNER_MANAGER_START */';b='/* DNX_SCANNER_MANAGER_END */'
if a in t and b in t:
 x,y=t.split(a,1);_,z=y.split(b,1);p.write_text(x+z)
PY
}
restart(){ if [[ $MODE == docker ]];then docker restart "$CONTAINER";else systemctl restart openwebrx 2>/dev/null||echo 'OpenWebRX bitte manuell neu starten.';fi;}
notice
case "$CMD" in
 install|update)
  [[ $EUID -eq 0 ]]||{ echo 'Bitte als root/sudo.';exit 1;};find_init;[[ -f $JS ]]||{ echo "$JS fehlt";exit 1;};cp -a "$INIT" "$INIT.backup-dnx-scanner-$(date +%F-%H%M%S)";remove_block;cat "$JS">>"$INIT";command -v node>/dev/null&&node --check "$INIT";restart;echo "Installiert: $INIT";;
 uninstall)
  [[ $EUID -eq 0 ]]||{ echo 'Bitte als root/sudo.';exit 1;};find_init;cp -a "$INIT" "$INIT.backup-dnx-scanner-$(date +%F-%H%M%S)";remove_block;restart;echo 'Entfernt; Backups bleiben erhalten.';;
 status)
  find_init;grep -qF "$MARK1" "$INIT"&&echo 'Scanner-Manager: installiert'||echo 'Scanner-Manager: nicht installiert';echo "$INIT";;
 help|*) cat <<'EOF'
Befehle:
  sudo ./install-dnx-scanner-manager.sh install
  sudo ./install-dnx-scanner-manager.sh update
  sudo ./install-dnx-scanner-manager.sh uninstall
  ./install-dnx-scanner-manager.sh status

Docker-Container ändern:
  CONTAINER=mein-container sudo -E ./install-dnx-scanner-manager.sh install

Native Installation:
  MODE=native sudo -E ./install-dnx-scanner-manager.sh install

Expliziter Pfad:
  PLUGIN_INIT=/pfad/htdocs/plugins/receiver/init.js sudo -E ./install-dnx-scanner-manager.sh install
EOF
esac
