#!/bin/bash
# Cierra la sesión Musa: informa del estado y recuerda escribir la documentación.
set -e
[ -f .musa/session.json ] || { echo "No hay sesión abierta (.musa/session.json)."; exit 1; }

echo "== Cambios sin commitear en dev =="
git status --short 2>/dev/null || true
echo; echo "== Mini-merges de esta sesión =="
[ -s .musa/merges.log ] && cat .musa/merges.log || echo "(ninguno)"

sed -i.bak 's/"session": "open"/"session": "closed"/' .musa/session.json && rm -f .musa/session.json.bak
mkdir -p docs
echo
echo "Sesión CERRADA. Ahora actualiza docs/SESSION_LATEST_ES.md y docs/ROADMAP.md"
echo "(incluye los mini-merges de arriba, lo pendiente y la recomendación para la próxima sesión)."

