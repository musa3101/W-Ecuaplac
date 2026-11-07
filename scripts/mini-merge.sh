#!/bin/bash
# Mini-merge / merge SIN cambiar la rama de la carpeta de trabajo (usa un worktree temporal).
#
# Uso:
#   mini-merge.sh "mensaje" archivo1 [archivo2 ...]   -> commit de ESOS archivos en dev y cherry-pick a main
#   mini-merge.sh --all                               -> merge completo de dev en main
#
# Opciones (el agente SOLO las pasa tras la doble confirmación del usuario):
#   --confirmed   obligatorio para ejecutar; sin él solo muestra qué haría (simulación)
#   --push        sube main a origin (despliega en Cloudflare si está conectado)
set -e

CONFIRMED=0; PUSH=0; ALL=0; MSG=""; FILES=()
for a in "$@"; do
  case "$a" in
    --confirmed) CONFIRMED=1 ;;
    --push) PUSH=1 ;;
    --all) ALL=1 ;;
    *) if [ -z "$MSG" ] && [ "$ALL" = 0 ]; then MSG="$a"; else FILES+=("$a"); fi ;;
  esac
done

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "No es un repositorio git."; exit 1; }
[ "$(git rev-parse --abbrev-ref HEAD)" = "dev" ] || { echo "Debes estar en dev."; exit 1; }
git rev-parse --verify main >/dev/null 2>&1 || { echo "No existe la rama main."; exit 1; }

if [ "$ALL" = 0 ] && { [ -z "$MSG" ] || [ ${#FILES[@]} -eq 0 ]; }; then
  echo "Uso: mini-merge.sh \"mensaje\" archivo... [--confirmed] [--push]   |   --all"; exit 1
fi

echo "== Plan =="
if [ "$ALL" = 1 ]; then
  echo "Merge completo dev -> main. Commits que entran:"; git log --oneline main..dev
  [ -z "$(git status --porcelain)" ] || echo "AVISO: hay cambios sin commitear en dev; NO entrarán."
else
  echo "Commit en dev SOLO de: ${FILES[*]}"; echo "Mensaje: $MSG"
  echo "Luego cherry-pick a main."
fi
[ "$PUSH" = 1 ] && echo "PUSH a origin/main -> DESPLEGARÁ la web en Cloudflare." || echo "Sin push (solo main local)."

if [ "$CONFIRMED" != 1 ]; then
  echo; echo "SIMULACIÓN. Nada se ha tocado. Falta la doble confirmación (--confirmed)."; exit 0
fi

SHA=""
if [ "$ALL" = 0 ]; then
  git add -- "${FILES[@]}"
  if git diff --cached --quiet -- "${FILES[@]}"; then echo "Esos archivos no tienen cambios."; exit 1; fi
  git commit -m "$MSG" -- "${FILES[@]}" >/dev/null
  SHA="$(git rev-parse HEAD)"
fi

WT="$(mktemp -d)/musa-wt"
cleanup() { git worktree remove --force "$WT" >/dev/null 2>&1 || true; }
trap cleanup EXIT
git worktree add "$WT" main >/dev/null 2>&1 || { echo "main está en uso en otro worktree/ventana."; exit 1; }

if [ "$ALL" = 1 ]; then
  ( cd "$WT" && git merge --no-ff dev -m "merge: dev -> main (autorizado por Musa)" ) \
    || { ( cd "$WT" && git merge --abort ) 2>/dev/null; echo "Conflicto: abortado, main intacta."; exit 1; }
else
  ( cd "$WT" && git cherry-pick "$SHA" >/dev/null ) \
    || { ( cd "$WT" && git cherry-pick --abort ) 2>/dev/null; echo "Conflicto: abortado, main intacta (el commit sigue en dev)."; exit 1; }
fi

if [ "$PUSH" = 1 ]; then ( cd "$WT" && git push origin main ); fi

mkdir -p .musa
echo "$(date +%Y-%m-%dT%H:%M:%S) | ${MSG:-merge completo} | ${FILES[*]:-all} | push=$PUSH" >> .musa/merges.log
echo "Hecho. La sesión sigue ABIERTA en dev (rama de la carpeta sin cambios)."

