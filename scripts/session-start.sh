#!/bin/bash
# Abre la sesión Musa: garantiza rama dev y crea .musa/session.json
set -e

mkdir -p .musa
STAMP="$(date +%Y-%m-%dT%H:%M:%S%z)"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  CUR="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
  if [ "$CUR" != "dev" ]; then
    git checkout dev 2>/dev/null || git checkout -b dev
  fi
  BRANCH="dev"
  # .musa es estado local: que Git lo ignore sin tocar el .gitignore del proyecto
  EXCL="$(git rev-parse --git-path info/exclude)"
  grep -qx ".musa/" "$EXCL" 2>/dev/null || echo ".musa/" >> "$EXCL"
else
  BRANCH="(sin repositorio)"
fi

cat > .musa/session.json <<EOF
{
  "session": "open",
  "branch": "$BRANCH",
  "started_at": "$STAMP",
  "rule": "Sesion Musa abierta. Trabajar en dev. Sin merge/push/deploy sin la frase 'Tienes mi OK, haz el merge' y doble confirmacion. Un merge NO cierra la sesion."
}
EOF
touch .musa/merges.log

echo "Sesion Musa ABIERTA. Rama: $BRANCH"
echo "Recuerda: sin merge sin 'Tienes mi OK, haz el merge' (+ doble confirmacion)."

